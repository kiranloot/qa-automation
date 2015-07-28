class AddIndexOnMonthYearToSubscriptionUnits < ActiveRecord::Migration
  def change
    add_index :subscription_units, :month_year
  end
end
