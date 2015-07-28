module RecurlyWorkers
  class CouponWorker
    include Sidekiq::Worker

    def perform(promotion_id)
      begin
        promotion = Promotion.find promotion_id

        RecurlyAdapter::CouponCreator.new(promotion).fulfill
      rescue => ex
        Airbrake.notify(ex, {
                                   component:  self.class.to_s,
                                   action:     "perform promotion_id #{ promotion_id }"
                                 })
      end
    end
  end
end
