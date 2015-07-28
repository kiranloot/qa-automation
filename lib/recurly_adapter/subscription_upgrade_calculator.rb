# Handles all calculations related to upgrading a subscription through Recurly.
module RecurlyAdapter
  class SubscriptionUpgradeCalculator
    attr_reader :upgrade_data, :account, :recurly_subscription

    def initialize(upgrade_data, account, recurly_subscription)
      @upgrade_data         = upgrade_data
      @account              = account
      @recurly_subscription = recurly_subscription
    end
    
    def upgrade_charge_amount_in_cents
      adjusted_plan_cost_in_cents - prorated_amount_in_cents
    end

    def prorated_amount_in_cents
      (cost_of_current_period_in_cents / current_period_term_length) * units_remaining
    end

    def cost_of_current_period_in_cents
      cost_in_cents = 0

      current_successful_transactions.each do |t|
        cost_in_cents += amount_in_cents_based_on_transaction_action(t)
      end

      cost_in_cents = upgrade_data.current_plan_total_cost_in_cents if cost_in_cents <= 0
      
      cost_in_cents
    end

    def current_successful_transactions
      account.transactions.select do |t|
        transaction_is_within_current_period?(t)
      end
    end

    def adjusted_plan_cost_in_cents
      upgrade_data.new_plan_total_cost_in_cents
    end

    private
      def transaction_is_within_current_period?(t)
        # Adding 1 hour to transaaction created_at to deal with Recurly's 
        # returning a current_period_started_at and transaction's created_at that 
        # are the same (possibly off a few seconds).
        (t.created_at + 1.hour) > current_period_started_at && t.status == 'success'
      end

      def next_assessment_at
        upgrade_data.next_assessment_at
      end

      def current_period_started_at
        recurly_subscription.current_period_started_at
      end

      def amount_in_cents_based_on_transaction_action(t)
        action = t.action

        case action
        when 'purchase'
          t.amount_in_cents
        when 'refund'
          -(t.amount_in_cents)
        else
          0
        end
      end

      def units_remaining
        upgrade_data.units_remaining
      end

      def current_period_term_length
        upgrade_data.current_period_term_length
      end

      def tax_amount_in_cents
        upgrade_data.tax_amount_in_cents
      end
  end
end