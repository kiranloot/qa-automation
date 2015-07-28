class AddStatusToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :subscription_status, :string, :default => "active"
  end
end
