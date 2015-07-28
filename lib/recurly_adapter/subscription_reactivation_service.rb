require 'activemodel_errors_standard_methods'

module RecurlyAdapter
  class SubscriptionReactivationService
    include ActiveModelErrorsStandardMethods

    attr_reader :data, :recurly_subscription_id

    def initialize(data)
      @data = data
    end

    def reactivate
      recurly_subscription = create_subscription

      if creation_errors = recurly_subscription.errors.presence
        handle_creation_errors(creation_errors)
      else
        set_recurly_subscription_id(recurly_subscription)
      end
    rescue => e
      handle_exception_errors(e)
    end

    private
      def account
        @account ||= Recurly::Account.find data.recurly_account_id
      end

      def create_subscription
        Recurly::Subscription.create! recurly_subscription_hash
      end

      def recurly_subscription_hash
        hash = {
          plan_code: data.current_plan_name,
          account: account,
          coupon_code: RecurlyAdapter::CouponCode.new(data.coupon_code).code
        }

        bill_date = next_bill_date
        if bill_date
          hash[:trial_ends_at] = bill_date
        end

        hash
      end

      def next_bill_date
        date = data.next_bill_date

        if date && date.respond_to?(:strftime)
          date.strftime("%FT%TZ")
        else
          date
        end
      end

      def handle_creation_errors(creation_errors)

        # creation_errors := [Hash] A hash with indifferent read access containing any
        #   validation errors where the key is the attribute name and the value is
        #   an array of error messages.
        # @example
        #   account.errors                # => {"account_code"=>["can't be blank"]}
        #   account.errors[:account_code] # => ["can't be blank"]

        creation_errors.each_pair do |attribute_key, error_msgs|
          error_msgs.each { |error_msg| errors.add attribute_key, error_msg }
        end
      end

      def handle_exception_errors(e)
        errors.add(:gateway_errors, e.message)
      end

      def set_recurly_subscription_id(subscription)
        @recurly_subscription_id ||= subscription.uuid
      end
  end
end
