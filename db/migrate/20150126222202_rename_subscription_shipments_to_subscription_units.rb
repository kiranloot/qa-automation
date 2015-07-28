class RenameSubscriptionShipmentsToSubscriptionUnits < ActiveRecord::Migration
  def change
    rename_table :subscription_shipments, :subscription_units
  end
end
