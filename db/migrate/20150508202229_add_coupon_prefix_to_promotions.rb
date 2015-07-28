class AddCouponPrefixToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :coupon_prefix, :string, limit: 50
    add_index :promotions, :coupon_prefix, unique: true
  end
end
