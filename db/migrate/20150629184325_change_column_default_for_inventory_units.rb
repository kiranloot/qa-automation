class ChangeColumnDefaultForInventoryUnits < ActiveRecord::Migration
  def change
    change_column_default :inventory_units, :in_stock, false
    change_column_default :inventory_units, :total_committed, 0
    change_column_default :inventory_units, :total_available, 0
  end
end
