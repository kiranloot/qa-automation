class AddMonthToSkipToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :month_to_skip, :date
  end
end
