require 'activemodel_errors_standard_methods'

class CouponValidator
  include ActiveModelErrorsStandardMethods

  attr_reader :plan

  def initialize(code, plan, trigger_event)
    @code          = code
    @plan          = plan
    @trigger_event = trigger_event
  end

  def validate!
    if coupon.nil?
      errors.add(:invalid_code, "#{code} is invalid.")
      return
    end

    check_trigger_event
    check_promotion_date
    check_plan_for_eligibility
    check_usage_limit
  end

  def valid?
    !errors.any?
  end

  def check_promotion_date
    current_date = Date.today

    if current_date < promotion.starts_at
      errors.add(:invalid_date, "Promotion starts on #{promotion.starts_at}")
    elsif current_date > promotion.ends_at
      errors.add(:invalid_date, "Promotion ended on #{promotion.ends_at}")
    end
  end

  def check_plan_for_eligibility
    unless promotion.eligible_plans.find_by_id(plan.id)
      errors.add(:ineligible_plan, "Selected plan is ineligible for this promotion.")
    end
  end

  def check_usage_limit
    return if !promotion.one_time_use && promotion.conversion_limit.nil?

    total_usage = promotion.coupons.pluck(:usage_count).sum

    if promotion.one_time_use && coupon.usage_count > 0
      errors.add(:already_used, 'Coupon already used.')
    elsif !promotion.one_time_use && total_usage >= promotion.conversion_limit
      errors.add(:limit_reached, 'Coupon usage limit reached')
    end
  end

  def check_trigger_event
    unless promotion.trigger_event.include?(@trigger_event)
      errors.add(:ineligible_trigger_event, "This coupon is not valid at #{@trigger_event}")
    end
  end

  def coupon
    @coupon ||= Coupon.includes(promotion: :eligible_plans)
      .where(
        plans_promotions: { plan_id: plan.id},
        coupons:          { code: code, status: 'Active' }
       ).first
  end

  def promotion
    @promotion ||= coupon.promotion
  end

  private

    def code
      "#{@code}".downcase
    end
end
