require 'spec_helper'

describe PromotionHandler do
  describe "#fulfill" do
    let(:subscription) { create(:subscription) }
    let(:coupon) { create(:coupon) }
    let(:data) do
      {
        coupon: coupon,
        product: subscription,
        product_total: 21.75,
        product_subtotal: 19.95,
        tax_rate: 0.09
      }
    end

    it "creates a promo_conversion" do
      promo_handler = PromotionHandler.new(data)

      expect{
        promo_handler.fulfill
      }.to change(PromoConversion, :count).by(1)
    end

    it "increase coupon's usage_count by 1" do
      promo_handler = PromotionHandler.new(data)

      expect{
        promo_handler.fulfill
        coupon.reload
      }.to change {coupon.usage_count}.by(1)
    end
  end
end