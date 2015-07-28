class AddSubscriptionIdToSubscriptionBackfillerJobs < ActiveRecord::Migration
  def change
    add_column :subscription_backfiller_jobs, :subscription_id, :integer
    add_index :subscription_backfiller_jobs, :subscription_id
  end
end
