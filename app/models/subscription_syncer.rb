class SubscriptionSyncer
  attr_reader :subscription

  def initialize(subscription, options = { sync_next_assessment_date: true, cc_last_four: true })
    @subscription = subscription

    # Get chargify subscription
    ChargifySwapper.set_chargify_site_for(@subscription)
    @chargify_subscription = Chargify::Subscription.find(@subscription.chargify_subscription_id)
    @options = options
  end

  def sync
    return false if @chargify_subscription.nil?

    sync_next_assessment_date if @options[:sync_next_assessment_date]
    sync_cc_last_four if @options[:cc_last_four]
    @subscription.save!
  end

  private

    def sync_next_assessment_date
      @subscription.next_assessment_at = @chargify_subscription.next_assessment_at
    end

    def sync_cc_last_four
      payment_profile = @chargify_subscription.payment_profile
      masked_card_number = payment_profile.masked_card_number
      last_four = masked_card_number.split('-').last
      @subscription.last_4 = last_four
    end
end
