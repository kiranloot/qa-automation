class RenameFriendbuyConversionToFriendbuyConversionEvent < ActiveRecord::Migration
  def up
    rename_table :friendbuy_conversions, :friendbuy_conversion_events
  end

  def down
    rename_table :friendbuy_conversion_events, :friendbuy_conversions
  end
end
