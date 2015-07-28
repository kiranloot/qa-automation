module SubscriptionWorkers
  class OrderHandler
    include Sidekiq::Worker

    def perform
      soh = Subscription::OrderHandler.new(Subscription.current_crate_month_year)
      soh.handle_orders
    end
  end
end
