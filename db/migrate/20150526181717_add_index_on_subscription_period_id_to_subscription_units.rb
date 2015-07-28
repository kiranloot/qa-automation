class AddIndexOnSubscriptionPeriodIdToSubscriptionUnits < ActiveRecord::Migration
  def change
    add_index :subscription_units, :subscription_period_id
  end
end
