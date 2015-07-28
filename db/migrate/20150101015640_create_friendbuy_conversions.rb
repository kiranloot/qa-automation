class CreateFriendbuyConversions < ActiveRecord::Migration
  def change
    create_table :friendbuy_conversions do |t|
      t.string :possible_self_referral
      t.string :share_id
      t.string :new_order_ip_address
      t.string :network
      t.string :share_campaign_id
      t.string :original_order_id
      t.string :new_order_id
      t.string :email
      t.string :share_campaign_name
      t.string :original_order_customer_id
      t.string :share_customer_id
      t.string :new_order_customer_id
      t.string :share_ip_address
      t.string :conversion_id
      t.timestamps
    end

    add_index :friendbuy_conversions, :share_customer_id
    add_index :friendbuy_conversions, :email
  end

end
