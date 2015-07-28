class AddCountryToPlans < ActiveRecord::Migration
  def up
    add_column :plans, :country, :string
  end

  def down
    remove_column :plans, :country
  end
end
