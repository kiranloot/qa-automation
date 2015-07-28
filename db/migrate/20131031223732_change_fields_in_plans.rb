class ChangeFieldsInPlans < ActiveRecord::Migration
  def up
    remove_column :plans, :cost_frequency
    add_column :plans, :period, :integer, default: 1
    add_column :plans, :shipping_and_handling, :float, default: 6.0
    add_column :plans, :savings_copy, :string, default: "Cancel Anytime"

    Plan.where(name: '1-month-subscription').first_or_create.update_attributes({cost: 19.37})
    Plan.where(name: '3-month-subscription').first_or_create.update_attributes({cost: 55.11, period: 3, savings_copy: "You Save $3!"})
    Plan.where(name: '6-month-subscription').first_or_create.update_attributes({cost: 105.99, period: 6, savings_copy: "You Save $10!"})
    Plan.where(name: 'ca-1-month-subscription').first_or_create.update_attributes({cost: 29.95, shipping_and_handling: 0.0})
    Plan.where(name: 'canadian-one-month').first_or_create.update_attributes({cost: 29.95, shipping_and_handling: 0.0})
    Plan.where(name: 'gb-1-month-subscription').first_or_create.update_attributes({cost: 29.95, shipping_and_handling: 0.0})
    Plan.where(name: 'au-1-month-subscription').first_or_create.update_attributes({cost: 29.95, shipping_and_handling: 0.0})
  end

  def down
    remove_column :plans, :period
    remove_column :plans, :shipping_and_handling
    remove_column :plans, :savings_copy
    add_column :plans, :cost_frequency, :text
  end
end
