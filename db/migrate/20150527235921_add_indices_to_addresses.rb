class AddIndicesToAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :subscription_id
    add_index :addresses, :type
  end
end
