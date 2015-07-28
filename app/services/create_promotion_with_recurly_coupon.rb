require 'activemodel_errors_standard_methods'

class CreatePromotionWithRecurlyCoupon
  extend ActiveModel::Translation
  include ActiveModelErrorsStandardMethods

  attr_reader :promotion, :eligible_plans

  def initialize(promotion, eligible_plans)
    @promotion      = promotion
    @eligible_plans = eligible_plans
  end

  def perform
    Promotion.transaction do
      persist_promotion
      create_external_coupon
      promotion.eligible_plans = eligible_plans
    end
  rescue
    # rollback
  end

  protected
  def persist_promotion
    merge_errors(promotion.errors) unless promotion.valid?
    promotion.save!
  end

  def create_external_coupon
    creator = RecurlyAdapter::CouponCreator.new(promotion)
    creator.fulfill

    if creator.errors.any?
      merge_errors(creator.errors)
      raise StandardError.new 'Failed to create coupon in Recurly'
    end
  end
end
