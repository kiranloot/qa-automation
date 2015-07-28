class CreateSubscriptionShipments < ActiveRecord::Migration
  def change
    create_table :subscription_shipments do |t|
      t.integer :subscription_id
      t.string :tracking_number
      t.string :shipstation_id
      t.string :carrier_code
      t.string :service_code
      t.string :month_year

      t.timestamps
    end
  end
end
