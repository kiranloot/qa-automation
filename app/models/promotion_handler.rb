# Should handle all tasks when a coupon is applied successfully.
class PromotionHandler
  attr_reader :coupon

  def initialize(options = {})
    @coupon           = options[:coupon]
    @product          = options[:product]
    @product_total    = options[:product_total]
    @product_subtotal = options[:product_subtotal]
    @tax_rate         = options[:tax_rate]
  end

  def fulfill
    return if coupon.nil? || !coupon.valid?

    create_conversion
    update_coupon_usage_count
  end

  def create_conversion
    promotion.promo_conversions.create(
      product_id: @product.id,
      product_type: @product.class.to_s,
      product_initial_cost: product_initial_cost,
      product_discounted_cost: @product_total,
      coupon_id: coupon.id
    )
  end

  private

    def update_coupon_usage_count
      coupon.usage_count += 1
      coupon.save
    end

    def promotion
      @promotion ||= coupon.promotion
    end

    def product_initial_cost
      @product_subtotal + (@product_subtotal * @tax_rate)
    end
end
