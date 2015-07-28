class AddChargifySubscriptionIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :chargify_subscription_id, :integer
  end
end
