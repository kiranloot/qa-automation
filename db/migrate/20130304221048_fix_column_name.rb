class FixColumnName < ActiveRecord::Migration
  def change
		rename_column :plans, :cost_frecuency, :cost_frequency
  end
end
