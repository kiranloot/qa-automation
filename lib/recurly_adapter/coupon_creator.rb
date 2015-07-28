require 'activemodel_errors_standard_methods'

class RecurlyAdapter::CouponCreator
  include ActiveModelErrorsStandardMethods

  attr_reader :promotion

  def initialize(promotion)
    @promotion = promotion
  end

  def fulfill
    recurly_coupon = Recurly::Coupon.new(recurly_coupon_params)
    merge_recurly_errors(recurly_coupon.errors) unless recurly_coupon.save
  end

  def recurly_coupon_params
    {
      coupon_code: promotion.coupon_prefix,
      name: promotion.name,
      discount_type: recurly_discount_type,
      discount_percent: recurly_discount_type == 'percent' ? promotion.adjustment_amount.to_i : nil,
      discount_in_cents: recurly_discount_type == 'dollars' ? (promotion.adjustment_amount * 100).to_i : nil,
      single_use: true,         # The lifespan determines how long a coupon will remain active on an account and how many invoices the coupon will be applied to.
      applies_to_all_plans: true,
    }.reject { |key, value| value.nil? }
  end

  def recurly_discount_type
    adjustment_type = promotion.adjustment_type.strip.downcase
    case adjustment_type
      when 'percentage'
        'percent'
      when 'fixed'
        'dollars'
      else
        adjustment_type
    end
  end
end
