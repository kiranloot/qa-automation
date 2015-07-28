class AddFlaggedInvalidAtToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :flagged_invalid_at, :datetime
    add_index :addresses, :flagged_invalid_at
  end
end
