require 'rails_helper'

WebMock.allow_net_connect!

RSpec.describe RecurlyAdapter::CouponCreator, type: :model do
  let!(:promotion) { build :promotion, adjustment_amount: 10.0 }
  let(:recurly_coupon_creator) { RecurlyAdapter::CouponCreator.new promotion }

  it { expect(promotion).to be_valid }

  describe '#fulfill' do
    let(:recurly_coupon) { double 'Recurly::Coupon' }
    before { allow(Recurly::Coupon).to receive(:new) { recurly_coupon } }
    subject { recurly_coupon_creator.fulfill }

    it 'calls Recurly::Coupon.save' do
      expect(recurly_coupon).to receive(:save) { true }
      subject
    end

    context 'Recurly::Coupon.save fails' do
      let(:attribute_key) { :attribute_key }
      let(:error_messages) { ['error_msg'] }
      before { allow(recurly_coupon).to receive(:save) { false } }

      it 'copies errors from Recurly::Coupon' do
        expect(recurly_coupon).to receive(:errors) { { attribute_key => error_messages } }

        subject
        expect(recurly_coupon_creator.errors).to include(attribute_key)
        expect(recurly_coupon_creator.errors[attribute_key]).to match_array(error_messages)
      end
    end
  end

  describe '#recurly_coupon_params' do
    subject { recurly_coupon_creator.recurly_coupon_params }

    it { expect(subject[:coupon_code]).to eq(promotion.coupon_prefix) }
    it { expect(subject[:name]).to eq(promotion.name) }
    it { expect(subject).not_to include(:hosted_description) }
    it { expect(subject).not_to include(:invoice_description) }
    it { expect(subject).not_to include(:redeem_by_date) }

    describe 'coupon account lifespan (single_use) is unrestricted' do
      # There is no relationship between Promotion.one_time_use and Recurly::Coupon.single_use
      # These tests are intended to prove that independence.
      context 'Promotion.single_use == true' do
        before { promotion.one_time_use = true }

        it { expect(subject[:single_use]).to be_truthy }
      end

      context 'Promotion.single_use == true' do
        before { promotion.one_time_use = false }

        it { expect(subject[:single_use]).to be_truthy }
      end
    end

    it { expect(subject).not_to include(:applies_for_months) }

    describe 'max_redemptions is unrestricted' do
      before { promotion.conversion_limit = 9999 }

      context 'Promotion is single use' do
        before { promotion.one_time_use = true }

        it { expect(subject).not_to include(:max_redemptions) }
      end

      context 'Promotion is multi use' do
        before { promotion.one_time_use = false }

        it { expect(subject).not_to include(:max_redemptions) }
      end
    end

    it { expect(subject).to include(:applies_to_all_plans) }
    it { expect(subject[:applies_to_all_plans]).to be_truthy }

    context 'promotion.adjustment_type is Percentage' do
      before { promotion.adjustment_type = 'Percentage' }

      it { expect(subject[:discount_type]).to eq('percent') }
      it { expect(subject[:discount_percent]).to eq(10) }
      it { expect(subject[:discount_percent]).to be_an Integer }
      it { expect(subject[:discount_in_cents]).to be_nil }
    end

    context 'promotion.adjustment_type is Fixed' do
      before { promotion.adjustment_type = 'Fixed' }

      it { expect(subject[:discount_type]).to eq('dollars') }
      it { expect(subject[:discount_percent]).to be_nil }
      it { expect(subject[:discount_in_cents]).to eq(1000.0) }
    end

    it { expect(subject).not_to include(:plan_codes) }
  end

  describe '#recurly_discount_type' do
    subject { recurly_coupon_creator.recurly_discount_type }

    context 'Promotion.adjustment_type == Percentage' do
      before { promotion.adjustment_type = 'Percentage' }

      it { expect(subject).to eq('percent') }
    end

    context 'Promotion.adjustment_type == Fixed' do
      before { promotion.adjustment_type = 'Fixed' }

      it { expect(subject).to eq('dollars') }
    end
  end
end
