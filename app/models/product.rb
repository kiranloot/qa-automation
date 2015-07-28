class Product < ActiveRecord::Base
  scope :level_up, -> { where(brand: 'Level Up') }
  has_many :plans
  has_many :variants

  def default_plan
    plans.detect { |plan| plan.period == 3 }
  end

  def sold_out?
    plans.joins(:subscriptions).count("subscriptions") >= max_inventory_count
  end
end
