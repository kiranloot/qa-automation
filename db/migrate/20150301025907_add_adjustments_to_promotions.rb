class AddAdjustmentsToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :adjustment_amount, :decimal, precision: 8, scale: 2
    add_column :promotions, :adjustment_type, :string
  end
end