class AddStatusToSubscriptionUnits < ActiveRecord::Migration
  def change
    add_column :subscription_units, :status, :string
  end
end
