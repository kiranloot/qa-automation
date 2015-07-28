class AddSubscriptionPeriodIdToSubscriptionUnits < ActiveRecord::Migration
  def change
    add_column :subscription_units, :subscription_period_id, :integer
  end
end
