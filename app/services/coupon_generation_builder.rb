class CouponGenerationBuilder
  attr_reader :coupon_prefix, :coupon_code, :admin_email
  def initialize(options = {})
    @length        = options[:char_length]
    @quantity      = options[:quantity]
    @recipients    = options[:recipients]
    @coupon_prefix = options[:coupon_prefix]
    @coupon_code   = options[:coupon_code]
    @admin_email   = options[:admin_email]
  end

  def length
    @length.to_i
  end

  def quantity
    @quantity.to_i
  end

  def recipients
    (@recipients.split(',') << admin_email).uniq
  end
end
