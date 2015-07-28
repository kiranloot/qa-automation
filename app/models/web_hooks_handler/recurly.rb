module WebHooksHandler
  class Recurly
    EVENTS = [
               'expired_subscription_notification',
               'renewed_subscription_notification',
               'updated_subscription_notification',
               'canceled_subscription_notification',
               'reactivated_account_notification',
               'past_due_invoice_notification',
               'successful_payment_notification',
               #remaining events sending 200 response to recurly only:
               'billing_info_updated_notification',
               'canceled_account_notification',
               'closed_invoice_notification',
               'failed_payment_notification',
               'new_account_notification',
               'new_invoice_notification',
               'new_subscription_notification',
               'successful_refund_notification',
               'void_payment_notification'
             ]

    def initialize(raw_payload)
      @raw_payload = raw_payload
    end

    def handle
      begin
        if event_is_valid?
          send(event)

          return true
        end
      rescue => e
        handle_error(e)

        return false
      end
    end

    private
      def successful_payment_notification
        if subscription
          subscription.update_attributes(subscription_status: 'active')
          subscription.current_period.update_attributes(status: 'active')
        end
      end

      def past_due_invoice_notification
        if subscription
          handle_dunning
        end
      end

      def handle_dunning
        subscription.update_attributes(subscription_status: 'past_due')
        subscription.current_period.update_attributes(status: 'past_due')
      end

      def expired_subscription_notification
        subscription.update_attributes!(
          paper_trail_event: 'canceled',
          subscription_status: 'canceled'
        )
        SubscriptionWorkers::EmailListStatusUpdater.perform_async subscription.user_id
        SubscriptionPeriod::Handler.new(subscription).handle_subscription_canceled
      end

      def renewed_subscription_notification
        SubscriptionPeriod::Handler.new(subscription).handle_subscription_renewed
      end

      def updated_subscription_notification
        set_plan_if_pending_upgrade
        subscription.update_attributes(
          next_assessment_at: subscription_payload[:current_period_ends_at],
          plan: plan
        )
      end

      def set_plan_if_pending_upgrade
        @plan = upgraded_subscription_plan if pending_subscription_present?
      end

      def pending_subscription_present?
        recurly_subscription_data.pending_subscription.present?
      end

      def recurly_subscription_data
        @recurly_subscription_data ||= RecurlyAdapter::SubscriptionDataRetriever.new(payload_subscription_uuid).subscription
      end

      def upgraded_subscription_plan
        Plan.find_by_name(@recurly_subscription_data.pending_subscription.plan_code)
      end

      # This is Recurly's concept of cancel at end of period.
      def canceled_subscription_notification
        subscription.update_attributes(
          cancel_at_end_of_period: true,
          paper_trail_event: 'initiated pending cancellation'
        )

        SubscriptionWorkers::CancellationEmail.perform_async(subscription.id, subscription.next_assessment_at)
        SubscriptionWorkers::EmailListStatusUpdater.perform_async(subscription.user_id)
      end

      # This is Recurly's concept of removing a cancel at end of period.
      def reactivated_account_notification
        subscription.update_attributes(
          cancel_at_end_of_period: nil,
          paper_trail_event: 'removed pending cancellation'
        )

        SubscriptionWorkers::RemoveCancellationEmail.perform_async(subscription.id)
        SubscriptionWorkers::EmailListStatusUpdater.perform_async(subscription.user_id)
      end

      def billing_info_updated_notification; end

      def canceled_account_notification; end

      def closed_invoice_notification; end

      def failed_payment_notification; end

      def new_account_notification; end
      
      def new_invoice_notification; end
      
      def new_subscription_notification; end
      
      def successful_refund_notification; end

      def void_payment_notification; end

      def subscription
        return nil if payload_subscription_uuid.nil?
        @subscription ||= Subscription.find_by_recurly_subscription_id payload_subscription_uuid
      end

      def plan
        @plan ||= Plan.find_by_name subscription_payload[:plan][:plan_code]
      end

      def event
        payload.keys[0]
      end

      def subscription_payload
        payload[event][:subscription] || {}
      end

      def invoice_payload
        payload[event][:invoice] || {}
      end

      def transaction_payload
        payload[event][:transaction] || {}
      end

      def payload_subscription_uuid
        subscription_payload[:uuid] || invoice_payload[:subscription_id] || transaction_payload[:subscription_id]
      end

      def payload
        @payload ||= Hash.from_xml(@raw_payload).to_h.with_indifferent_access
      end

      def event_is_valid?
        EVENTS.include? event
      end

      def handle_error(e)
        Airbrake.notify(
          error_class:       'Recurly WebHooksHandler:',
          error_message:     "Failed to handle webhook (#{event}): #{e.message}. Payload: #{payload}",
          backtrace:         $ERROR_POSITION,
          environment_name:  ENV['RAILS_ENV']
        )
      end
  end
end