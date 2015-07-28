class RemoveUserFromAddresses < ActiveRecord::Migration
  def up
    remove_column :addresses, :user_id
  end

  def down
    add_column :addresses, :user_id, :integer
  end
end
