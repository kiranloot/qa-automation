class UpdateStoreCreditsForRedemption < ActiveRecord::Migration
  def up
    rename_column :store_credits, :user_id, :referrer_user_id
    add_column :store_credits, :referrer_user_email, :string
    add_column :store_credits, :referred_user_id, :integer
    add_column :store_credits, :referred_user_email, :string
    add_column :store_credits, :status, :string

    add_index :store_credits, :referred_user_id
    add_index :store_credits, :referrer_user_id
  end

  def down

    remove_index :store_credits, column: :referred_user_id
    remove_index :store_credits, column: :referrer_user_id

    rename_column :store_credits, :referrer_user_id, :user_id
    remove_column :store_credits, :referrer_user_email
    remove_column :store_credits, :referred_user_id
    remove_column :store_credits, :referred_user_email
    remove_column :store_credits, :status
  end
end
