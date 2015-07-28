module PricingInfoHelper
  def show_pricing_info_text_for(plan)
    plan.country == 'US' ? ' /mo + $6 S/H' : ' /mo S&H Included!'
  end

  def show_price_per_month(plan)
    plan.cost / plan.period
  end

  def show_price_per_month_without_shipping(plan)
    if plan.country == 'US'
      plan.cost / plan.period - plan.shipping_and_handling
    else
      plan.cost / plan.period
    end
  end
end
