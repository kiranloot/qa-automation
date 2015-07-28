class Subscription
  class CurrentUnit
    class << self
      def find(period)
        period.subscription_units.detect {|ss|
          ss.month_year == Subscription::CrateDateCalculator.current_crate_month_year
        }
      end
    end
  end
end
