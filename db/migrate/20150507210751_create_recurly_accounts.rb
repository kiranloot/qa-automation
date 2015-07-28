class CreateRecurlyAccounts < ActiveRecord::Migration
  def change
    create_table :recurly_accounts do |t|
      t.string :recurly_account_id
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :recurly_accounts, :users
  end
end
