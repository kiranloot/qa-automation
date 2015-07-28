class AddCurrentToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :current, :boolean
  end
end
