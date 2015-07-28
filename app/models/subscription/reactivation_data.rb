class Subscription::ReactivationData
  attr_reader :subscription, :coupon, :next_bill_date

  def initialize(subscription, coupon, next_bill_date=nil)
    @subscription   = subscription
    @coupon         = coupon
    @next_bill_date = next_bill_date
  end

  def current_plan_name
    subscription.plan_name
  end

  def current_plan_cost
    subscription.plan_cost
  end

  def current_plan_period
    subscription.plan_period
  end

  def recurly_account_id
    subscription.recurly_account_id
  end

  def shipping_address_zip
    subscription.shipping_address.zip
  end

  def tax_rate
    # TODO: Implement me when AvaTax info is available.
    0
  end

  def coupon_amount
    coupon.total_discount_amount(current_plan_cost)
  end

  def coupon_code
    coupon.code
  end
end
