class CreateSubscriptionPeriods < ActiveRecord::Migration
  def change
    create_table :subscription_periods do |t|
      t.references :subscription, index: true
      t.string :status
      t.integer :term_length
      t.datetime :start_date
      t.datetime :expected_end_date
      t.datetime :actual_end_date

      t.timestamps null: false
    end
    add_foreign_key :subscription_periods, :subscriptions
  end
end
