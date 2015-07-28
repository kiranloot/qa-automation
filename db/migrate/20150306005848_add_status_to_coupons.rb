class AddStatusToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :status, :string, default: 'Active'
  end
end
