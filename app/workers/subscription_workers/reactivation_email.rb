module SubscriptionWorkers
  class ReactivationEmail
    include Sidekiq::Worker

    def perform(sub_id)
      sub = Subscription.find sub_id

      SubscriptionMailer.reactivated_subscription(sub).deliver_now
    end
  end
end