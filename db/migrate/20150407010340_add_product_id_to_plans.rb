class AddProductIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :product_id, :integer
    add_index :plans, :product_id
  end
end
