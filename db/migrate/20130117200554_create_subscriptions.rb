class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions, :force => true do |t|
      t.references :user
      t.string :shirt_size
      t.integer :customer_id
      t.references :plan
      t.float :cost
      t.belongs_to :billing_address
      t.belongs_to :shipping_address
      t.string :looter_name
      t.string :coupon_code
      t.string :last_4
      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :plan_id
    add_index :subscriptions, :billing_address_id
    add_index :subscriptions, :shipping_address_id
  end
end
