class CreateSubscriptionBackfillerJobs < ActiveRecord::Migration
  def change
    create_table :subscription_backfiller_jobs do |t|
      t.string :account_code
      t.string :plan_code
      t.datetime :starts_at
      t.datetime :next_assessment_at
      t.decimal :balance, precision: 8, scale: 2
      t.string :status

      t.timestamps null: false
    end
    add_index :subscription_backfiller_jobs, :status
  end
end
