class RenameCouponCodesToCoupons < ActiveRecord::Migration
  def up
    rename_table :coupon_codes, :coupons
  end

  def down
    rename_table :coupons, :coupon_codes
  end
end
