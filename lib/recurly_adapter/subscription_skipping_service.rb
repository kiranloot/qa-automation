module RecurlyAdapter
  class SubscriptionSkippingService
    attr_reader :subscription

    def initialize(uuid)
      @subscription = Recurly::Subscription.find uuid
    end

    def skip_a_month
      begin
        subscription.postpone skipped_to
      rescue => e
        process_error(e)
        return false
      end
    end

    def skipped_to
      @skipped_to ||= current_period_ends_at.next_month
    end

    private
      def current_period_ends_at
        @current_period_ends_at ||= subscription.current_period_ends_at
      end

      def process_error(e)
        Airbrake.notify(
          error_class:       'Subscription Skip Error:',
          error_message:     "Failed to skip a month for recurly subscription uuid #{subscription.uuid}. Reason: #{e.message}",
          backtrace:         $ERROR_POSITION,
          environment_name:  ENV['RAILS_ENV']
        )
      end
  end
end