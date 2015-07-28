class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user
      t.string :line_1
      t.string :line_2
      t.string :state
      t.string :city
      t.string :zip
      t.string :type

      t.timestamps
    end
    add_index :addresses, :user_id
  end
end
