# Analytics class
# Responsible for executing neccessary API to track subscriber's activity
module Analytics
  class Purchase
    include Rails.application.routes.url_helpers

    def initialize(user, options)
      @user = user
      @plan_name = options[:plan_name]
      @subscription_id = options[:subscription_id]
      @total = options[:total]
      @campaign_id = options[:campaign_id]
    end

    def track_subscription_purchase
      sailthru_client.purchase(@user.email, purchased_items, nil,
                               @campaign_id)
    end

    def sailthru_client
      @sailthru_client ||= Sailthru::Client.new(
        ENV['SAILTHRU_API_KEY'],
        ENV['SAILTHRU_API_SECRET'],
        ENV['SAILTHRU_API_URL']
      )
    end

    private

    def purchased_items
      [{
        qty: 1,
        title: @plan_name,
        id: @subscription_id,
        price: @total,
        url: 'https://www.lootcrate.com/subscriptions'
      }]
    end
  end
end
