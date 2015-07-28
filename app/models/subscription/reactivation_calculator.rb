class Subscription::ReactivationCalculator
  attr_reader :data

  def initialize(reactivation_data)
    @data = reactivation_data
  end

  def preview
    {
      total_payment: total_payment,
      amount_saved: coupon_amount,
      plan_name: current_plan_name
    }
  end
  
  def total_payment
    @total_payment = current_plan_cost

    coupon_adjustment
    tax_adjustment

    @total_payment
  end

  def next_assessment_at
    if LootcrateConfig.within_rebill_adjustment_rule?
      readjusted_next_billing_date
    else
      LootcrateConfig.current_datetime + data.current_plan_period.months
    end
  end

  private

    def readjusted_next_billing_date
      bill_date = LootcrateConfig.current_datetime
      bill_date = bill_date.change(day: 5)
      bill_date += data.current_plan_period.months
    end

    def current_plan_name
      data.current_plan_name
    end

    def current_plan_cost
      data.current_plan_cost
    end

    def coupon_adjustment
      @total_payment -= coupon_amount
    end

    def tax_adjustment
      tax_retriever = TaxRetriever.new(data.shipping_address_zip, amount: @total_payment)
      result        = tax_retriever.get_tax_details

      @total_payment += result[:tax_amount]
    end

    def coupon_amount
      data.coupon_amount
    end
end