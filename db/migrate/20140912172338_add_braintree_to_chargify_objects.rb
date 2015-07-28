class AddBraintreeToChargifyObjects < ActiveRecord::Migration
  def change
    add_column :subscriptions, :braintree, :boolean
    add_column :chargify_customers, :braintree, :boolean
  end
end
