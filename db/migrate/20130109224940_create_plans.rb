class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.float :cost
      t.text :cost_frecuency

      t.timestamps
    end
  end
end
