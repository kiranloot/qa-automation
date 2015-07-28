class CreateInventoryUnits < ActiveRecord::Migration
  def change
    create_table :inventory_units do |t|
      t.boolean :in_stock
      t.integer :variant_id
      t.integer :total_committed
      t.integer :total_available
      t.timestamps null: false
    end
  end
end
