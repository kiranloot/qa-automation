class AddLastPaymentDateToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :last_payment_date, :datetime
    add_column :subscriptions, :creation_date, :datetime
  end
end
