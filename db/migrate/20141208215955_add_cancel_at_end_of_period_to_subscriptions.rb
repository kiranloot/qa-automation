class AddCancelAtEndOfPeriodToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :cancel_at_end_of_period, :boolean
  end
end
