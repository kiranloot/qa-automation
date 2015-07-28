class AddCreationReasonToSubscriptionPeriods < ActiveRecord::Migration
  def change
    add_column :subscription_periods, :creation_reason, :string
  end
end
