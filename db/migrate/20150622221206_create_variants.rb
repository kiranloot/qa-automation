class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :sku
      t.string :name
      t.integer :product_id
      t.boolean :is_master
      t.timestamps null: false
    end
  end
end
