require 'spec_helper'

RSpec.describe Subscription::CreationHandler do
  let(:user) { create(:user) }
  let(:checkout) do
    build(:checkout,
      :with_billing_info,
      :with_shipping_info,
      :with_credit_card_info
    )
  end
  let(:handler) do
    Subscription::CreationHandler.new(
      checkout: checkout,
      user: user
    )
  end
  let(:subscription_creation_service) { double('subscription_creation_service') }

  describe "#fulfill" do
    context "when it creates gateway Subscription" do
      before do
        handler.stub(:create_gateway_subscription).and_return(true)
      end

      it "handles successful creation" do
        expect(handler).to receive(:handle_successful_creation)

        handler.fulfill
      end
    end

    context "when it fails to create a gateway Subscription" do
      before do
        handler.stub(:create_gateway_subscription).and_return(true)
        handler.stub_chain('errors.any?').and_return(true)
      end

      it "does not handle successful creation" do
        expect(handler).to_not receive(:handle_successful_creation)

        handler.fulfill
      end
    end
  end

  # TODO: Should only test that actions are taken, and test actions separately.
  describe "#handle_successful_creation" do
    let(:gateway) do
      double('gateway', {
        customer: double('customer', id: 1),
        subscription: double('subscription', id: 1),
        account: double('account'),
        account_id: 123,
        subscription_id: '123'
      })
    end

    after { Timecop.return }

    before do
      allow(handler).to receive(:gateway).and_return(gateway)
      Timecop.freeze(DateTime.new(2015, 01, 05))
    end

    it "creates a database subscription" do
      expect{
        handler.handle_successful_creation
      }.to change(Subscription, :count).by(1)
    end

    it "creates a Recurly customer account" do
      expect{
        handler.handle_successful_creation
      }.to change(RecurlyAccount, :count).by(1)
    end

    it "creats a checkout" do
      expect{
        handler.handle_successful_creation
      }.to change(Checkout, :count).by(1)
    end

    it "handles promotion usage" do
      expect_any_instance_of(PromotionHandler).to receive(:fulfill)

      handler.handle_successful_creation
    end

    it "sends welcome email" do
      expect{
        handler.handle_successful_creation
      }.to change(SubscriptionWorkers::WelcomeEmail.jobs, :size).by(1)
    end

    it "updates email list" do
      expect{
        handler.handle_successful_creation
      }.to change(SubscriptionWorkers::EmailListUpdater.jobs, :size).by(1)
    end

    it "creates a subscription period" do
      expect{
        handler.handle_successful_creation
      }.to change(SubscriptionPeriod, :count).by(1)
    end

    context "when date is within rebill adjustment rule" do
      before { Timecop.freeze(DateTime.new(2015, 01, 07)) }

      it "readadjust rebill date" do
        expect_any_instance_of(Subscription).to receive(:readjust_rebilling_date)

        handler.handle_successful_creation
      end
    end

    context "when date is NOT within rebill adjustment rule" do
      before { Timecop.freeze(DateTime.new(2015, 01, 05)) }

      it "it does not readadjust rebill date" do
        expect_any_instance_of(Subscription).to_not receive(:readjust_rebilling_date)

        handler.handle_successful_creation
      end
    end
  end

  describe 'save_checkout' do
    before do
      allow_any_instance_of(Rails.configuration.subscription_creation_service).to receive(:subscription_id).and_return('1')
      allow(subscription_creation_service).to receive(:account_id).and_return('2')
      allow(handler).to receive(:database_subscription).and_return(double('db_sub', id: '2'))
    end

    it 'saves the recurly subscription id' do
      handler.save_checkout

      expect(checkout.recurly_subscription_id).to eq('1')
      expect(checkout.subscription_id).to eq(2)
    end
  end
end
