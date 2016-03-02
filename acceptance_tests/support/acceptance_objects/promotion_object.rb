class Promotion
  attr_accessor :one_time_use, :trigger, :adjustment_type, :adjustment_amount, :base_coupon_code, :coupon_code

  def initialize(one_time_use=false, trigger='SIGNUP', adjustment_type='Fixed', adjustment_amount=10)
    @one_time_use = one_time_use
    @trigger = trigger
    @adjustment_type = adjustment_type
    @adjustment_amount = adjustment_amount
  end

  def one_time_use?
    one_time_use
  end
end
