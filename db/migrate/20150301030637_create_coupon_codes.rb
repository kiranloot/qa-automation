class CreateCouponCodes < ActiveRecord::Migration
  def change
    create_table :coupon_codes do |t|
      t.string :code
      t.integer :usage_count

      t.timestamps
    end
  end
end
