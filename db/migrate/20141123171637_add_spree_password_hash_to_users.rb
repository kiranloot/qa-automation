class AddSpreePasswordHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spree_password_hash, :string
    add_column :users, :spree_password_salt, :string
  end
end
