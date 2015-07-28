require 'activemodel_errors_standard_methods'

class Subscription::Reactivator
  include ActiveModelErrorsStandardMethods

  attr_reader :subscription, :next_bill_date

  def initialize(subscription, options = {})
    @subscription   = subscription
    @coupon_code    = options[:coupon_code]
    @next_bill_date = options[:next_bill_date]
  end

  def reactivate
    reactivation_service.reactivate

    if service_errors = reactivation_service.errors.presence
      handle_errors service_errors
    else
      handle_successful_reactivation
    end
  end

  def preview
    calculator.preview
  end

  private
    def reactivation_service
      @reactivation_service ||= RecurlyAdapter::SubscriptionReactivationService.new(reactivation_data)
    end

    def reactivation_data
      @reactivation_data ||= Subscription::ReactivationData.new(subscription, coupon, next_bill_date)
    end

    def calculator
      @calculator ||= Subscription::ReactivationCalculator.new(reactivation_data)
    end

    def coupon
      @coupon ||= validate_coupon
    end

    def validate_coupon
      coupon_validator = CouponValidator.new(@coupon_code, subscription.plan, 'REACTIVATION')

      coupon_validator.validate!

      coupon_validator.valid? ? coupon_validator.coupon : NullCoupon.new
    end

    def handle_successful_reactivation
      save_subscription_data

      SubscriptionWorkers::ReactivationEmail.perform_async subscription.id
      SubscriptionWorkers::EmailListStatusUpdater.perform_async subscription.user.id
      handle_promotion_usage
      handle_subscription_period
      readjust_rebill_date
    end

    def handle_errors(service_errors)
      service_errors.each { |attribute_key, error_msg| errors.add attribute_key, error_msg }
    end

    def save_subscription_data
      subscription.paper_trail_event = 'reactivated'
      subscription.update_attributes(
        subscription_status: 'active',
        cancel_at_end_of_period: nil,
        next_assessment_at: calculator.next_assessment_at,
        recurly_subscription_id: reactivation_service.recurly_subscription_id
      )
    end

    def handle_promotion_usage
      handler = PromotionHandler.new(
        coupon: coupon,
        product: subscription,
        product_total: calculator.total_payment,
        product_subtotal: reactivation_data.current_plan_cost,
        tax_rate: reactivation_data.tax_rate
      )

      handler.fulfill
    end

    def handle_subscription_period
      SubscriptionPeriod::Handler.new(subscription).handle_subscription_reactivated
    end

    def readjust_rebill_date
      return unless LootcrateConfig.within_rebill_adjustment_rule?

      RecurlyWorkers::MoveRebillDate.perform_async(reactivation_service.recurly_subscription_id, calculator.next_assessment_at)
    end
end
