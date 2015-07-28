require 'spec_helper'

describe Subscription do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:shirt_size)}
    it { is_expected.to validate_presence_of(:subscription_status)}
    it 'should validate association billing address' do
      subscription = FactoryGirl.build(
        :subscription,
        :billing_address => build(:bad_billing_address))
      expect(subscription).not_to be_valid
    end

    it 'should validate association shipping address' do
      subscription = FactoryGirl.build(
        :subscription,
        :shipping_address => build(:bad_shipping_address))
      expect(subscription).not_to be_valid
    end
  end

  describe "Associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:billing_address) }
    it { is_expected.to belong_to(:shipping_address) }
    it { is_expected.to have_many(:subscription_periods) }
  end

  describe '#month_skipped' do
    let(:current_time) { Date.new(2014, 12, 10) }
    let(:subscription) { create(:subscription) }
    after { Timecop.return }

    context "when this month is skipped" do
      context 'and it is within this month crate month' do
        it "returns this month year" do
          Timecop.freeze(current_time)
          create(:subscription_skipped_month, month_year: 'DEC2014', subscription: subscription)

          expect(subscription.month_skipped).to eq 'DEC2014'
        end
      end

      context 'and it is NOT within this month crate month' do
        it 'does not return this month year' do
          Timecop.freeze(current_time.change(day: 21))
          create(:subscription_skipped_month, month_year: 'DEC2014', subscription: subscription)

          expect(subscription.month_skipped).to_not eq 'DEC2014'
        end
      end
    end

    context 'when next month is skipped' do
      it 'returns next month year' do
        Timecop.freeze(current_time)
        create(:subscription_skipped_month, month_year: 'JAN2015', subscription: subscription)

        expect(subscription.month_skipped).to eq 'JAN2015'
      end
    end
  end

  describe "Scopes" do
    describe ".oldest_active" do
      it 'returns the oldest active subscription' do
        user = create(:user)
        older_sub = create(:subscription, created_at: 3.days.ago, user: user)
        create(:subscription, created_at: 2.days.ago, user: user)
        expect(user.subscriptions.oldest_active).to eq older_sub
      end
    end
  end

  it '#has_corrupt_mapping? detection' do
    sub1 = FactoryGirl.create(:subscription)
    sub2 = FactoryGirl.create(:subscription, user: sub1.user, customer_id: sub1.customer_id)

    expect(sub2.has_corrupt_mapping?).to eq(true)
  end

  it '#has_corrupt_mapping? should be false after remapping' do
    sub1 = FactoryGirl.create(:subscription)
    sub2 = FactoryGirl.create(:subscription, user: sub1.user, customer_id: 23423)

    expect(sub2.has_corrupt_mapping?).to eq(false)
  end

  describe '#readjust_rebilling_date' do
    context 'between the 6th and the 19th' do
      let(:subscription) { create(:subscription) }
      let(:postponement_service_injector) { Class.new {include PostponementServiceInjector} }
      let(:postponement_service) { postponement_service_injector.new.postponement_service_klass }

      before { (Timecop.freeze(2014, 2, 7)) }
      it 'readjust next_billing_date to the 5th' do
        expected_billing_datetime = DateTime.new(2015, 3, 5)
        expect_any_instance_of(postponement_service).to receive(
          :readjust_rebilling_date).with(expected_billing_datetime)

        subscription.readjust_rebilling_date(expected_billing_datetime)
      end
      after { Timecop.return }
    end
  end

  describe "#current_period" do
    let(:subscription) { create(:subscription, subscription_status: 'active') }

    it "returns current period" do
      active_period = create(:active_subscription_period,
        subscription_id: subscription.id
      )

      result = subscription.current_period

      expect(result).to eq active_period
    end
  end

  describe "#latest_period" do
    it "returns latest period" do
      p1 = build(:subscription_period, status: 'canceled')
      p2 = build(:subscription_period, status: 'canceled')
      subscription = create(:subscription, subscription_periods: [p1, p2])

      expect(subscription.latest_period).to eq p2
    end
  end

  describe "#redeem_store_credits" do
    #let!(:user) { create(:user) }
    #let!(:subscription) { create(:subscription, user: user) }
    #let!(:store_credit) { create(:store_credit, referrer_user_id: user.id) }
    it 'redeems all store credit' do
      pending # Not sure why this test is not receiving the redeem call
      store_credit = create(:store_credit, referrer_user_id: user.id)
      expect(store_credit).to receive(:redeem)

      subscription.redeem_store_credits
    end
  end
end
