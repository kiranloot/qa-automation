class AddNewOrderCustomerEmailToFriendbuyConversionEvents < ActiveRecord::Migration
  def change
    add_column :friendbuy_conversion_events, :new_order_customer_email, :string
  end
end
