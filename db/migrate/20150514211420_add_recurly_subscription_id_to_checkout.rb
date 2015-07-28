class AddRecurlySubscriptionIdToCheckout < ActiveRecord::Migration
  def change
    add_column :checkouts, :recurly_subscription_id, :string
    add_index :checkouts, :recurly_subscription_id
  end
end
