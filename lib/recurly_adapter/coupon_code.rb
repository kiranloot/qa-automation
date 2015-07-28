class RecurlyAdapter::CouponCode
  def initialize(coupon_code)
    @coupon_code = coupon_code
  end

  def coupon
    unless defined?(@coupon)
      @coupon = Coupon.find_by_code(@coupon_code.to_s.strip.downcase)
    end
    @coupon
  end

  def promotion
    @promotion ||= coupon.try(:promotion)
  end

  def code
    promotion.try(:coupon_prefix)
  end
end
