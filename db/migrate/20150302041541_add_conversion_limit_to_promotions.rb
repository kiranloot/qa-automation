class AddConversionLimitToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :conversion_limit, :integer
  end
end
