class AddShipstationOrderNumberToSubscriptionShipments < ActiveRecord::Migration
  def change
    add_column :subscription_shipments, :shipstation_order_number, :string
    add_index :subscription_shipments, :shipstation_order_number
  end
end
