class AddCouponIdToPromoConversions < ActiveRecord::Migration
  def change
    add_column :promo_conversions, :coupon_id, :integer
  end
end
