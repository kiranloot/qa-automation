module SubscriptionWorkers
  class CancellationEmail
    include Sidekiq::Worker

    def perform(sub_id, next_assessment_at)
      sub = Subscription.find sub_id

      if is_levelup_product?(sub)
        SubscriptionMailer.levelup_cancel_at_end_of_period(sub, next_assessment_at).deliver_now
      else
        SubscriptionMailer.cancel_at_end_of_period(sub, next_assessment_at).deliver_now
      end
    end

    private
      def is_levelup_product?(sub)
        sub.plan.product_brand == 'Level Up'
      end
  end
end