class AddDefaultValuesForLevelUpFields < ActiveRecord::Migration
  def change
    change_column :inventory_units, :total_available, :integer, default: 0
    change_column :inventory_units, :total_committed, :integer, default: 0
    change_column :inventory_units, :in_stock, :boolean, default: false
  end
end
