class NullCoupon
  def valid?
    false
  end

  def total_discount_amount(cost)
    0
  end

  def code
    nil
  end
end
