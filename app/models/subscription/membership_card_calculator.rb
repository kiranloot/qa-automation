class Subscription
  class MembershipCardCalculator
    class << self
      def third_subscription_crate_in_lifetime?(subscription)
        (subscription.is_active? &&
         Subscription::CrateDateCalculator.current_crate_date >  (subscription.adjusted_creation_date + 2.months) &&
         Subscription::CrateDateCalculator.current_crate_date <= (subscription.adjusted_creation_date + 3.months) &&
         (subscription.last_payment_date >= (Subscription::CrateDateCalculator.last_20th - subscription.period_months))) rescue false
      end
    end
  end
end
