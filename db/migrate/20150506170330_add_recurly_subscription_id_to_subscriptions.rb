class AddRecurlySubscriptionIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :recurly_subscription_id, :string
    add_index :subscriptions, :recurly_subscription_id
  end
end
