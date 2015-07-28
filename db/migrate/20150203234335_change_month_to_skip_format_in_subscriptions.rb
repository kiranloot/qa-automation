class ChangeMonthToSkipFormatInSubscriptions < ActiveRecord::Migration
  def up
    change_column :subscriptions, :month_to_skip, :string
  end

  def down
    change_column :subscriptions, :month_to_skip, :date
  end
end
