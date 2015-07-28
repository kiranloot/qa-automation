require 'activemodel_errors_standard_methods'

# Handles all cancellation tasks
class Subscription::Canceller
  include ActiveModelErrorsStandardMethods

  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def cancel_immediately
    cancellation_service.cancel_immediately

    if cancellation_errors = cancellation_service.errors.presence
      handle_errors(cancellation_errors)
    else
      handle_successful_immediate_cancellation
    end
  end

  def cancel_at_end_of_period
    cancellation_service.cancel_at_end_of_period

    if cancellation_errors = cancellation_service.errors.presence
      handle_errors(cancellation_errors, true)
    else
      handle_successful_cancel_at_end_of_period
    end
  end

  def remove_cancel_at_end_of_period
    cancellation_service.remove_cancel_at_end_of_period

    if reactivation_errors = cancellation_service.errors.presence
      handle_errors(reactivation_errors)
    else
      handle_successful_remove_cancel_at_end_of_period
    end
  end

  private
    def cancellation_service
      @cancellation_service ||= RecurlyAdapter::SubscriptionCancellationService.new(subscription)
    end

    def handle_successful_immediate_cancellation
      subscription.update_attributes(subscription_status: 'canceled')
      cancel_unshipped_crates
    end

    def cancel_unshipped_crates
      current_period = subscription.current_period
      current_unit   = Subscription::CurrentUnit.find(current_period)
      current_unit.try(:cancel)
    end

    def handle_successful_cancel_at_end_of_period
      subscription.update_attributes!(
        cancel_at_end_of_period: true,
        paper_trail_event: 'initiated pending cancellation'
      )
      SubscriptionWorkers::CancellationEmail.perform_async(subscription.id, cancellation_service.subscription_expiration_date)
      SubscriptionWorkers::EmailListStatusUpdater.perform_async subscription.user.id
    end

    def handle_successful_remove_cancel_at_end_of_period
      subscription.update_attributes!(
        paper_trail_event: 'removed pending cancellation',
        cancel_at_end_of_period: nil
      )
      SubscriptionWorkers::EmailListStatusUpdater.perform_async subscription.user_id
      SubscriptionWorkers::RemoveCancellationEmail.perform_async subscription.id
    end


    def handle_errors(cancellation_errors, airbrake = false)
      errors.add(:cancellation_error, cancellation_errors.full_messages)

      if airbrake
        Airbrake.notify(
          error_class:       'Subscription Cancellation Error:',
          error_message:     "Failed to cancel subscription: #{subscription}: subscription_id: #{subscription.id}",
          backtrace:         $ERROR_POSITION,
          environment_name:  ENV['RAILS_ENV']
        )
      end
    end
end
