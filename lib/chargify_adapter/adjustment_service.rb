module ChargifyAdapter
  class AdjustmentService
    def initialize(subscription, amount_in_cents, options={})
      @subscription = subscription
      @amount_in_cents = amount_in_cents
      @options = options
    end

    def create
      memo = @options[:memo]
      chargify_subscription.adjustment(amount_in_cents: @amount_in_cents, memo: memo)
    end

    private
    def chargify_subscription
      ChargifySwapper.set_chargify_site_for(@subscription)
      Chargify::Subscription.find(@subscription.chargify_subscription_id)
    end
  end
end
