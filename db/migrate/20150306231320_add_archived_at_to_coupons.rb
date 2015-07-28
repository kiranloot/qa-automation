class AddArchivedAtToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :archived_at, :datetime
  end
end
