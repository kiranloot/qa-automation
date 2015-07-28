class CreateChargifyCustomers < ActiveRecord::Migration
  def change
    create_table :chargify_customers do |t|
			t.integer :user_id
      t.integer :chargify_customer_id

      t.timestamps
    end
  end
end
