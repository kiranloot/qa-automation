class CreateSubscriptionSkippedMonths < ActiveRecord::Migration
  def change
    create_table :subscription_skipped_months do |t|
      t.references :subscription, index: true
      t.string :month_year

      t.timestamps null: false
    end
    add_foreign_key :subscription_skipped_months, :subscriptions
  end
end
