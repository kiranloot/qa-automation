require 'activemodel_errors_standard_methods'

class Subscription::Skipper
  include ActiveModelErrorsStandardMethods
  include LootcrateCoreDates

  SKIP_CUTOFF_DAY = 5
  attr_reader :subscription, :errors

  def initialize(subscription)
    @subscription = subscription
  end

  def skip_a_month
    if skipping_service.skip_a_month
      handle_successful_skip
    else
      errors.add(:skip_a_month, 'Failed to skip a month.')
    end
  end

  def month_to_skip
    after_current_month_skip_day? ? next_month_year : current_month_year
  end

  def month_to_skip_image
    after_current_month_skip_day? ? next_month : current_month
  end

  private
    def skipping_service
      @skipping_service ||= RecurlyAdapter::SubscriptionSkippingService.new(subscription.recurly_subscription_id)
    end

    def handle_successful_skip
      subscription.update_attributes(next_assessment_at: skipping_service.skipped_to)
      create_skipped_month
      handle_subscription_period
      send_confirmation_email
    end

    def create_skipped_month
      subscription.subscription_skipped_months.create(
        month_year: month_to_skip
      )
    end

    def handle_subscription_period
      SubscriptionPeriod::Handler.new(@subscription).handle_subscription_skipped
    end

    def after_current_month_skip_day?
      current_datetime.day >= SKIP_CUTOFF_DAY
    end

    def send_confirmation_email
      SubscriptionWorkers::SkipEmail.perform_async(subscription.id)
    end
end
