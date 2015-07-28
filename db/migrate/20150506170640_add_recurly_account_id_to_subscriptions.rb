class AddRecurlyAccountIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :recurly_account_id, :string
    add_index :subscriptions, :recurly_account_id
  end
end
