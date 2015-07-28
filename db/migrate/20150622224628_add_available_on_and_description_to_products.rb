class AddAvailableOnAndDescriptionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :available_on, :datetime
    add_column :products, :description, :text
  end
end
