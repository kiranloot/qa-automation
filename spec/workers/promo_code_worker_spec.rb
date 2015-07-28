require 'spec_helper'

RSpec.describe PromoCodeWorker do
  describe '#perform' do
    context "when successful" do
      it "persists coupons to promotion, and sends email" do
        promotion              = create(:promotion)
        recurly_coupon_creator = instance_double(RecurlyAdapter::CouponCreator)
        worker                 = PromoCodeWorker.new

        expect{ 
          worker.perform(promotion.id, 'a@test.com', 'coupon', 10, 10) 
          promotion.reload
        }.to change{ promotion.coupons.size }.by(10)

        expect{
          worker.perform(promotion.id, 'a@test.com', 'coupon', 10, 10) 
        }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when it fails" do
      it "sends an error email" do
        promotion              = create(:promotion)
        recurly_coupon_creator = instance_double(RecurlyAdapter::CouponCreator)
        worker                 = PromoCodeWorker.new

        expect{
          worker.perform(promotion.id, 'a@test.com', 'coupon', 7, 100) 
        }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
