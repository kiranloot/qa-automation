class Subscription
  module Reporting
    class Aggregates
      class << self
        def active_by_shirt_size
          Subscription.active.group(:shirt_size).count
        end

        def active_by_plan
          Subscription.active.group(:plan).count
        end

        def subscription_status
          Subscription.group(:subscription_status).count
        end
      end
    end
  end
end
