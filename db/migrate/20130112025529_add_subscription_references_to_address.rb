class AddSubscriptionReferencesToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :subscription_id, :integer
  end
end
