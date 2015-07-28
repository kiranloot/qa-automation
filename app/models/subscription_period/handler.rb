class SubscriptionPeriod::Handler
  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def handle_subscription_created
    subscription.subscription_periods.create(
      status: 'active',
      term_length: term_length,
      start_date: DateTime.now,
      expected_end_date: expected_end_date,
      creation_reason: 'subscription_created'
    )
  end

  def handle_subscription_renewed
    new_period = nil

    begin
      ActiveRecord::Base.transaction do
        update_current_period_for_renewal
        new_period = create_new_period_for_renewal
      end
    rescue => e
      Airbrake.notify(
        error_class:       'Handle Subscription Renewed Error',
        error_message:     "Failed to handle subscription_renewed for #{subscription.id}. Reason: #{e}",
        backtrace:         $ERROR_POSITION,
        environment_name:  ENV['RAILS_ENV']
      )
    end

    new_period
  end

  def handle_subscription_reactivated
    subscription.subscription_periods.create(
      status: 'active',
      term_length: term_length,
      start_date: DateTime.now,
      expected_end_date: expected_end_date,
      creation_reason: 'subscription_reactivated'
    )
  end

  def handle_subscription_upgraded
    new_period = nil

    ActiveRecord::Base.transaction do
      update_current_period_for_upgrade
      new_period = create_new_period_for_upgrade
    end

    new_period
  end

  def handle_subscription_canceled
    return unless current_period

    current_period.update_attributes(
      status: 'canceled',
      actual_end_date: DateTime.now
    )
  end

  def handle_subscription_skipped
    current_period.update_attributes(
      expected_end_date: subscription.next_assessment_at
    )
  end

  private
    def create_new_period_for_renewal
      creation_reason = 'subscription_renewed'
      check_for_duplicate_period_creation!(creation_reason)

      subscription.subscription_periods.create!(
        status: 'active',
        term_length: term_length,
        start_date: DateTime.now,
        expected_end_date: expected_end_date,
        creation_reason: creation_reason
      )
    end

    def update_current_period_for_renewal
      current_period.update_attributes!(
        status: 'renewed',
        actual_end_date: current_period.expected_end_date
      )
    end

    def create_new_period_for_upgrade
      subscription.subscription_periods.create!(
        status: 'active',
        term_length: term_length,
        start_date: DateTime.now,
        expected_end_date: expected_end_date,
        creation_reason: 'subscription_upgraded'
      )
    end

    def update_current_period_for_upgrade
      current_period.update_attributes!(
        status: 'upgraded',
        actual_end_date: DateTime.now
      )
    end

    def term_length
      @term_length ||= subscription.plan_period
    end

    def expected_end_date
      @expected_end_date ||= subscription.next_assessment_at
    end

    def current_period
      @current_period ||= subscription.current_period
    end

    def check_for_duplicate_period_creation!(creation_reason)
      raise 'Duplicate period' if subscription.subscription_periods.where(start_date: 1.hour.ago..1.minute.ago, creation_reason: creation_reason).present?
    end
end
