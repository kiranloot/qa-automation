module SubscriptionWorkers
  class RemoveCancellationEmail
    include Sidekiq::Worker

    def perform(sub_id)
      sub = Subscription.find sub_id

      SubscriptionMailer.undo_cancellation_at_end_of_period(sub).deliver_now
    end
  end
end