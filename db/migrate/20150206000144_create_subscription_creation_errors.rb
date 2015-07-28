class CreateSubscriptionCreationErrors < ActiveRecord::Migration
  def change
    create_table :subscription_creation_errors do |t|
      t.integer :user_id
      t.string :user_email
      t.integer :chargify_subscription_id

      t.timestamps
    end
  end
end
