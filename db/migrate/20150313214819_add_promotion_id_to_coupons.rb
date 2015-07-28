class AddPromotionIdToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :promotion_id, :integer
    add_index "coupons", ["promotion_id"], :name => "index_coupons_on_promotion_id"
  end
end
