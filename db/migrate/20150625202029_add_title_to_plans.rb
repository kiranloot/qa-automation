class AddTitleToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :title, :string
  end
end
