class AddTriggerEventToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :trigger_event, :string
  end
end
