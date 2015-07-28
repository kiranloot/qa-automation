require 'spec_helper'

RSpec.describe Checkout do

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:plan) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:shipping_address_first_name) }
  it { is_expected.to validate_presence_of(:shipping_address_first_name) }
  it { is_expected.to validate_presence_of(:shipping_address_last_name) }
  it { is_expected.to validate_presence_of(:shipping_address_line_1) }
  it { is_expected.to validate_presence_of(:shipping_address_city) }
  it { is_expected.to validate_presence_of(:shipping_address_state) }
  it { is_expected.to validate_presence_of(:shipping_address_zip) }
  it { is_expected.to validate_presence_of(:shipping_address_country) }
  it { is_expected.to validate_presence_of(:billing_address_full_name) }
  it { is_expected.to validate_presence_of(:billing_address_line_1) }
  it { is_expected.to validate_presence_of(:billing_address_city) }
  it { is_expected.to validate_presence_of(:billing_address_state) }
  it { is_expected.to validate_presence_of(:billing_address_zip) }
  it { is_expected.to validate_presence_of(:billing_address_country) }
  it { is_expected.to validate_presence_of(:credit_card_number) }
  it { is_expected.to validate_presence_of(:credit_card_expiration_date) }
  it { is_expected.to validate_presence_of(:credit_card_cvv) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:plan) }

  after { Timecop.return }

  describe '#fulfill' do
    let(:user) { build(:user) }
    let(:plan) { build(:plan) }
    let(:checkout) do build(:checkout,
      :with_billing_info,
      :with_shipping_info,
      :with_chargify_subscription_id,
      :with_credit_card_info
    )
    end

    context "when it fails to fulfill" do
      it "adds errors" do
        creation_handler = double('creation_handler',
          fulfill: true,
          errors: {bad: 'bad'}
        )
        allow(checkout).to receive(:creation_handler).and_return(creation_handler)

        checkout.fulfill

        expect(checkout.errors.any?).to eq true
      end
    end

    context "when it fulfills" do
      it "does not add any errors" do
        creation_handler = double('creation_handler',
          fulfill: true,
          errors: {}
        )
         allow(checkout).to receive(:creation_handler).and_return(creation_handler)

        checkout.fulfill

        expect(checkout.errors.any?).to eq false
      end
    end
  end

  describe '#validate_coupon' do
    context 'valid coupon' do
      let(:coupon) { create(:coupon) }
      let(:plan) { build(:plan) }
      let(:checkout) { build(:checkout, plan: plan, coupon_code: coupon.code) }
      let!(:promotion) { create(:promotion, coupons: [coupon], eligible_plans: [plan]) }

      it 'returns valid coupon' do
        expect(checkout.coupon.valid?).to eq(true)
      end
    end

    context 'invalid coupon' do
      let(:plan) { build(:plan) }
      let(:checkout) { build(:checkout, plan: plan, coupon_code: 'invalidcode') }
      it 'returns an invalid_coupon object' do
        expect(checkout.coupon.valid?).to eq false
      end
    end

    context "when no coupon_code provided" do
      let(:coupon) { create(:coupon) }
      let(:plan) { build(:plan) }
      let(:checkout) { build(:checkout, plan: plan, coupon_code: '') }
      let!(:promotion) { create(:promotion, coupons: [coupon], eligible_plans: [plan]) }

      it "returns a null_coupon" do
        expect(checkout.coupon).to be_a NullCoupon
      end
    end

    context "when no plan is provided" do
      let(:coupon) { create(:coupon) }
      let(:plan) { build(:plan) }
      let(:checkout) { build(:checkout, plan: nil, coupon_code: '') }
      let!(:promotion) { create(:promotion, coupons: [coupon], eligible_plans: [plan]) }

      it "returns a null_coupon" do
        expect(checkout.coupon).to be_a NullCoupon
      end
    end
  end

  describe 'billing_address_first_name' do
    let(:plan) { build(:plan) }
    let(:checkout) { build(:checkout, plan: plan, billing_address_full_name: 'Jeff Test' ) }
    it 'should return Jeff' do
      expect(checkout.billing_address_first_name).to eq 'Jeff'
    end
  end

  describe 'billing_address_last_name' do
    let(:plan) { build(:plan) }
    let(:checkout) { build(:checkout, plan: plan, billing_address_full_name: 'Jeff de la Cruz' ) }
    it 'should return Jeff' do
      expect(checkout.billing_address_last_name).to eq 'de la Cruz'
    end
  end

end
