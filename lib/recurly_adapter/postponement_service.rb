require 'activemodel_errors_standard_methods'

module RecurlyAdapter
  # Readjust next billing date
  class PostponementService
    include ActiveModelErrorsStandardMethods

    def initialize(subscription)
      @subscription = subscription
    end

    def readjust_rebilling_date(date)
      if date < Date.today
        @errors.add(:postponement_service, "Date cannot be in the past")
      else
        begin
          recurly_subscription.postpone date
        rescue => e
          @errors.add(:postponement_service, e.message)
        end
      end
    end

    private
    def recurly_subscription
      Recurly::Subscription.find(@subscription.recurly_subscription_id)
    end
  end
end
