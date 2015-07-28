require 'spec_helper'

RSpec.describe NullCoupon do
  let(:coupon) { NullCoupon.new }

  describe "#valid?" do
    it "returns false" do
      expect(coupon.valid?).to eq false
    end
  end

  describe "#total_discount_amount(cost)" do
    it "returns 0" do
      expect(coupon.total_discount_amount(20.00)).to eq 0
    end
  end

  describe "#code" do
    it "returns nil" do
      expect(coupon.code).to be_nil
    end
  end
end