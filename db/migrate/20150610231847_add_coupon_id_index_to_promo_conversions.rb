class AddCouponIdIndexToPromoConversions < ActiveRecord::Migration
  def change
    add_index :promo_conversions, :coupon_id
  end
end
