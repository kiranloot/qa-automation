# This class should calculates all things related to cost of an order.
class OrderCalculator
  def initialize(args = {})
    @products             = args[:products]
    @shipping_address_zip = args[:shipping_address_zip]
    @coupon               = args[:coupon]
  end

  attr_reader :products, :shipping_address_zip, :coupon

  def subtotal
    @subtotal ||= products.map(&:cost).sum
  end

  def subtotal_with_tax_included
    total = subtotal + (subtotal * tax_rate)

    total.round(2)
  end

  def plan_renewal_cost
    taxable? ? subtotal_with_tax_included : subtotal
  end

  def total
    @total = [subtotal - coupon_discount_amount + tax_charge_amount, 0].max

    @total.to_f.round(2)
  end

  def tax_rate
    tax_details[:rate]
  end

  def tax_region
    tax_details[:region]
  end

  def coupon_discount_amount
    coupon.total_discount_amount(subtotal)
  end

  # Tax is applied on the discounted subtotal
  def tax_charge_amount
    [subtotal - coupon_discount_amount, 0].max * tax_rate
  end

  # Returns the next billing date.
  def next_assessment_at
    if require_readjustment?
      readjusted_next_billing_date
    else
      current_datetime + plan_period.months
    end
  end

  def readjusted_next_billing_date
    bill_date = current_datetime
    bill_date = bill_date.change(day: 5)
    bill_date += plan_period.months
  end

  private
    def taxable?
      tax_rate > 0
    end

    def tax_details
      @tax_details ||= TaxRetriever.new(shipping_address_zip).get_tax_details
    end

    def current_datetime
      LootcrateConfig.current_datetime
    end

    def require_readjustment?
      LootcrateConfig.within_rebill_adjustment_rule?
    end

    # This is assuming that we only allowed multiple purchases of a plan.
    def plan_period
      products.first.period
    end
end