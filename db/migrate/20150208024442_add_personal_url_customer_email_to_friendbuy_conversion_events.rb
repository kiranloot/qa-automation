class AddPersonalUrlCustomerEmailToFriendbuyConversionEvents < ActiveRecord::Migration
  def change
    add_column :friendbuy_conversion_events, :personal_url_customer_email, :string
  end
end
