class SetOneTimeUseDefaultPromotions < ActiveRecord::Migration
  def change
    change_column_default :promotions, :one_time_use, false
    change_column_null    :promotions, :one_time_use, false
  end
end
