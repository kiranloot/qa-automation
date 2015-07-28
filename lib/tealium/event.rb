############ DO NOT COMMIT THIS...file needs work since i removed enumerize gem
module Tealium
  # This class is created for encapsulating Tealium Event information inside a class.
  # Currently, only convertro requires this class but I can forsee us sending Tealium
  # Event information once Tealium produces a Event API
  class Event
#    extend Enumerize
    attr_accessor :event_type, :user, :subscription

#    enumerize :event_type, in: [:new_subscription_creation_success]

    def initialize(options = {})
      options = defaults.merge(options)
      @user = options[:user]
      @subscription = options[:subscription]
      @event_type = options[:event_type]
    end

    # Return convertro event type.  It is specific to convertro and not many
    # tracking pixels uses event type
    def convertro_event_type
      if event_type == :new_subscription_creation_success
        user_new_or_repeat + '.transaction-' +
          plan_period_length_in_months.to_s + 'mo'
      end
    end

    def defaults
      {
        event_type: 'undefined'
      }
    end

    private

    def user_new_or_repeat
      user.is_new_subscriber? ? 'new' : 'repeat'
    end

    def plan
      return nil if subscription.nil?
      subscription.plan
    end

    def plan_period_length_in_months
      plan.period
    end
  end
end
