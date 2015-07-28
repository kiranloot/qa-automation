require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

require 'clockwork'

include Clockwork

interval = Integer(ENV['SOH_INTERVAL_MINUTES'] || 60)

every(interval.minutes, 'Queueing Subscription Order Handler job') { SubscriptionWorkers::OrderHandler.perform_async }
