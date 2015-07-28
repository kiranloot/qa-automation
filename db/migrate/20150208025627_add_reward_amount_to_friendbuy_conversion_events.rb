class AddRewardAmountToFriendbuyConversionEvents < ActiveRecord::Migration
  def change
    add_column :friendbuy_conversion_events, :reward_amount, :string
  end
end
