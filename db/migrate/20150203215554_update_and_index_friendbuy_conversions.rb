class UpdateAndIndexFriendbuyConversions < ActiveRecord::Migration
  def change
    add_index :friendbuy_conversions, :conversion_id, unique: true
    change_column :friendbuy_conversions, :conversion_id, 'integer USING CAST(conversion_id AS integer)'
    change_column :friendbuy_conversions, :new_order_id, 'integer USING CAST(new_order_id AS integer)'
    change_column :friendbuy_conversions, :share_customer_id, 'integer USING CAST(share_customer_id AS integer)'
    change_column :friendbuy_conversions, :new_order_customer_id, 'integer USING CAST(new_order_customer_id AS integer)'
  end
end
