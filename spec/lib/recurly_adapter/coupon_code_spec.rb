require 'spec_helper'

RSpec.describe RecurlyAdapter::CouponCode, type: :model do
  let(:coupon_code) { 'coupon-code' }
  subject { RecurlyAdapter::CouponCode.new coupon_code }

  describe '#coupon' do
    context 'coupon_code exists in our system' do
      before { @coupon = create :coupon, code: coupon_code }

      it { expect(subject.coupon).to eq(@coupon) }
    end

    context 'coupon_code is not in our system' do
      it { expect(subject.coupon).to be_nil }
    end
  end

  describe '#promotion' do
    context '#coupon returns an valid object' do
      before do
        @promotion = instance_double(Promotion)
        expect(subject).to receive(:coupon) { instance_spy(Coupon, promotion: @promotion) }
      end

      it { expect(subject.promotion).to eq(@promotion) }
    end

    context '#coupon returns nil' do
      before do
        expect(subject).to receive(:coupon) { nil }
      end

      it { expect(subject.promotion).to be_nil }
    end
  end

  describe '#code' do
    context '#promotion is a valid object' do
      before do
        @coupon_prefix = 'coupon_prefix'
        expect(subject).to receive(:promotion) { instance_spy(Promotion, coupon_prefix: @coupon_prefix) }
      end

      it { expect(subject.code).to eq(@coupon_prefix) }
    end

    context '#promotion is nil' do
      before { expect(subject).to receive(:promotion) { nil }}

      it { expect(subject.code).to eq(nil) }
    end
  end
end
