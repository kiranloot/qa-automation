module SubscriptionWorkers
  class SkipEmail
    include Sidekiq::Worker

    def perform(sub_id)
      subscription = Subscription.find sub_id

      SubscriptionMailer.skip_a_month(subscription).deliver_now
    end
  end
end
