require 'activemodel_errors_standard_methods'

class Subscription::Upgrader
  include ActiveModelErrorsStandardMethods

  attr_reader :subscription, :desired_plan

  def initialize(subscription, desired_plan)
    @subscription = subscription
    @desired_plan = desired_plan
  end

  def upgrade
    service_upgrader.upgrade

    if service_errors = service_upgrader.errors.presence
      handle_failed_upgrade(service_errors)
    else
      handle_successful_upgrade
    end
  end

  def preview
    service_upgrader.preview
  end

  private
    def service_upgrader
      RecurlyAdapter::SubscriptionUpgradeService.new(upgrade_data)
    end

    def upgrade_data
      Subscription::UpgradeData.new(subscription, desired_plan)
    end

    def handle_successful_upgrade
      save_subscription_data
      send_upgrade_confirmation_email
      handle_subscription_period
    end

    def handle_subscription_period
      SubscriptionPeriod::Handler.new(subscription).handle_subscription_upgraded
    end

    def handle_failed_upgrade(service_errors)
      errors.add(:upgrade, service_errors.full_messages)
    end

    def save_subscription_data
      subscription.paper_trail_event  = 'upgraded'
      subscription.plan_id            = desired_plan.id
      subscription.next_assessment_at = upgrade_data.next_assessment_at
      subscription.save
    end

    def send_upgrade_confirmation_email
      SubscriptionWorkers::UpgradeEmail.perform_async(subscription.id)
    end
end
