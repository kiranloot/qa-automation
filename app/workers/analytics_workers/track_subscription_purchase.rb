module AnalyticsWorkers
  class TrackSubscriptionPurchase
    include Sidekiq::Worker

    def perform(user_id, plan_name, subscription_id, total, campaign_id)
      user = User.find(user_id)
      Analytics::Purchase.new(user,
                    plan_name: plan_name,
                    subscription_id: subscription_id,
                    total: total,
                    campaign_id: campaign_id).track_subscription_purchase
    end
  end
end
