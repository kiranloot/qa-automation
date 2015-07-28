module SubscriptionWorkers
  class EmailListUpdater
    include Sidekiq::Worker

    def perform(user_id)
      user = User.find user_id

      Sailthru::ListManager.new(user).update_new_subscription
    end
  end
end
