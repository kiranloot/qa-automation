class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.integer :quantity
      t.string :chargify_coupon_code
      t.references :user
      t.references :plan

      t.timestamps
    end
    add_index :checkouts, :user_id
    add_index :checkouts, :plan_id
  end
end
