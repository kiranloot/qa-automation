require 'activemodel_errors_standard_methods'

module RecurlyAdapter
  class SubscriptionCancellationService
    include ActiveModelErrorsStandardMethods

    attr_reader :subscription

    def initialize(subscription)
      @subscription = subscription
    end

    def cancel_immediately
      begin
        recurly_subscription.terminate
      rescue => e
        errors.add(:cancel_immediately, e.message)
      end
    end

    def cancel_at_end_of_period
      begin
        recurly_subscription.cancel
      rescue => e
        errors.add(:cancel_at_end_of_period, e.message)
      end
    end

    def remove_cancel_at_end_of_period
      begin
        recurly_subscription.reactivate
      rescue => e
        errors.add(:remove_cancel_at_end_of_period, e.message)
      end
    end

    def subscription_expiration_date
      recurly_subscription.expires_at
    end

    private
      def recurly_subscription
        @recurly_subscription ||= Recurly::Subscription.find(subscription.recurly_subscription_id)
      end
  end
end
