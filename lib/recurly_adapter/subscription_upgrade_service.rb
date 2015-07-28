require 'activemodel_errors_standard_methods'

module RecurlyAdapter
  class SubscriptionUpgradeService
    include ActiveModelErrorsStandardMethods

    attr_reader :upgrade_data

    def initialize(upgrade_data)
      @upgrade_data = upgrade_data
    end

    def upgrade
      begin
        charge_user_account_for_upgrade
        upgrade_subscription_in_recurly
      rescue => e
        handle_errors(e)
      end
    end

    def preview
      {
        charge_in_cents: calculator.adjusted_plan_cost_in_cents,
        prorated_amount_in_cents: calculator.prorated_amount_in_cents,
        payment_due_in_cents: calculator.upgrade_charge_amount_in_cents
      }
    end

    private
      def upgrade_subscription_in_recurly
        RecurlyWorkers::UpgradeSubscription.perform_async(recurly_subscription.uuid, upgrade_data.plan_name, upgrade_data.next_assessment_at)
      end

      def charge_user_account_for_upgrade
        begin
          adjustment = recurly_account.adjustments.create!(
            currency: 'USD',
            unit_amount_in_cents: calculator.upgrade_charge_amount_in_cents,
            tax_exempt: true,
            description: 'Charge for upgrades'
          )

          recurly_account.invoice!
        rescue => e
          RecurlyWorkers::RemoveAdjustment.perform_async(adjustment.try(:uuid))
          raise "Upgrade Charge Failure: #{e.message}"
        end
      end
      
      def recurly_subscription
        @recurly_subscription ||= ::Recurly::Subscription.find(upgrade_data.recurly_subscription_id)
      end

      def recurly_account
        @recurly_account ||= recurly_subscription.account
      end

      def calculator
        @calculator ||= RecurlyAdapter::SubscriptionUpgradeCalculator.new(upgrade_data, recurly_account, recurly_subscription)
      end

      def handle_errors(e)
        errors.add(:upgrade_error, e.message)
      end

      def upgrade_preview
        @upgrade_preview ||= RecurlyAdapter::SubscriptionPreviewService.upgrade(
            upgrade_data.recurly_account_id,
            upgrade_data.plan_name,
            calculator.upgrade_charge_amount_in_cents
          )
      end
  end
end
