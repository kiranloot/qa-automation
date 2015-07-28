class CreatePromoConversions < ActiveRecord::Migration
  def change
    create_table :promo_conversions do |t|
      t.integer :product_id
      t.integer :promotion_id
      t.string :product_type
      t.decimal :product_initial_cost, precision: 8, scale: 2
      t.decimal :product_discounted_cost, precision: 8, scale: 2

      t.timestamps
    end
  end
end
