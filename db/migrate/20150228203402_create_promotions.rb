class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.date :starts_at
      t.date :ends_at
      t.text :description
      t.string :name
      t.boolean :one_time_use

      t.timestamps
    end
  end
end
