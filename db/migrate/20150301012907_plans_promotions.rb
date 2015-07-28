class PlansPromotions < ActiveRecord::Migration
  def up
    create_table :plans_promotions, id: false do |t|
      t.integer :plan_id
      t.integer :promotion_id
    end

    add_index :plans_promotions, [:plan_id, :promotion_id]
  end

  def down
    drop_table :plans_promotions
  end
end