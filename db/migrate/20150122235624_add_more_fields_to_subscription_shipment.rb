class AddMoreFieldsToSubscriptionShipment < ActiveRecord::Migration
  def change
    add_column :subscription_shipments, :shirt_size, :string
    add_column :subscription_shipments, :netsuite_sku, :string
    add_column :subscription_shipments, :shipping_address_id, :integer

    add_index :subscription_shipments, :shirt_size
  end
end
