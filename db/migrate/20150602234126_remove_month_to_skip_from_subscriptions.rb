class RemoveMonthToSkipFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :month_to_skip
  end
end
