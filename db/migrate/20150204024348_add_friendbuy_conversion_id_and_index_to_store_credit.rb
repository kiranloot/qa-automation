class AddFriendbuyConversionIdAndIndexToStoreCredit < ActiveRecord::Migration
  def change
    add_column :store_credits, :friendbuy_conversion_id, :integer
    add_index :store_credits, :friendbuy_conversion_id, unique: true
  end
end
