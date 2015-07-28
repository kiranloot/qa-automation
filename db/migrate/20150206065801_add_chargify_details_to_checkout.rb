class AddChargifyDetailsToCheckout < ActiveRecord::Migration
  def change
    add_column :checkouts, :chargify_subscription_id, :integer
    add_column :checkouts, :coupon_code, :string
    add_column :checkouts, :subscription_id, :integer
  end
end
