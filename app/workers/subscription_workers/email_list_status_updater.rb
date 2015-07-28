module SubscriptionWorkers
  class EmailListStatusUpdater
    include Sidekiq::Worker

    def perform(user_id)
      user = User.find user_id

      MailChimp::ListManager.new(user).update_subscription_status
      unless Rails.env == 'production'
        Sailthru::ListManager.new(user).update_subscription_status
      end
    end
  end
end