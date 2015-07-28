class Subscription::UpgradeData
  attr_reader :subscription, :new_plan

  def initialize(subscription, new_plan)
    @subscription = subscription
    @new_plan     = new_plan
  end

  def recurly_subscription_id
    subscription.recurly_subscription_id
  end

  def recurly_account_id
    subscription.recurly_account_id
  end

  def next_assessment_at
    next_billing_date = LootcrateConfig.current_datetime + new_plan.period.months
    upgraded_date     = LootcrateConfig.within_rebill_adjustment_rule? ? readjusted_next_billing_date : next_billing_date

    upgraded_date + month_skipped_adjustment
  end

  def plan_cost_in_cents
    (new_plan.cost * 100).to_i
  end

  def plan_cost
    new_plan.cost
  end

  def shipping_address_zip
    subscription.shipping_address.zip
  end

  def units_remaining
    current_period.units_remaining
  end

  def plan_name
    new_plan.name
  end

  def current_period_term_length
    current_period.term_length
  end

  def new_plan_total_cost_in_cents
    plan_cost_in_cents + new_plan_tax_amount_in_cents
  end

  def current_plan_total_cost_in_cents
    total = [current_plan_cost - current_plan_coupon_discount_amount + current_plan_tax_charge_amount, 0].max

    (total * 100).round
  end

  private
    def current_plan_coupon_discount_amount
      promo_data      = PromoConversion.where(product_id: subscription.id).order(created_at: :asc).last
      discount_amount = 0

      if promo_data && coupon = promo_data.coupon
        discount_amount = coupon.total_discount_amount(current_plan_cost).to_f
      end

      discount_amount
    end

    def current_plan_tax_charge_amount
      [current_plan_cost - current_plan_coupon_discount_amount, 0].max * tax_rate
    end

    def new_plan_tax_amount_in_cents
      tax_details[:tax_amount_in_cents]
    end

    def tax_details
      tax_retriever = TaxRetriever.new(
        shipping_address_zip,
        amount: plan_cost
      )

      @tax_details ||= tax_retriever.get_tax_details
    end

    def tax_rate
      tax_details[:rate]
    end

    def current_period
      @current_period ||= subscription.current_period
    end

    def month_skipped_adjustment
      subscription.month_skipped.present? ? 1.month : 0.month
    end

    def readjusted_next_billing_date
      bill_date = LootcrateConfig.current_datetime
      bill_date = bill_date.change(day: 5)
      bill_date += (new_plan.period.months + adjust_rebill_month_for_unit_created)
    end

    def adjust_rebill_month_for_unit_created
      current_unit = Subscription::CurrentUnit.find(current_period)

      current_unit ? 1.months : 0.months
    end

    def current_plan
      @current_plan ||= subscription.plan
    end

    def current_plan_cost
      current_plan.cost
    end
end