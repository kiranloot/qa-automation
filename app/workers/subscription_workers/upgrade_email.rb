module SubscriptionWorkers
  class UpgradeEmail
    include Sidekiq::Worker

    def perform(sub_id)
      sub = Subscription.find sub_id

      SubscriptionMailer.upgrade(sub).deliver_now
    end
  end
end