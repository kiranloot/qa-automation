class Variant < ActiveRecord::Base
  belongs_to :product
  has_one :inventory_unit

  delegate :in_stock?, to: :inventory_unit
  delegate :total_committed, to: :inventory_unit, prefix: true
  delegate :total_available, to: :inventory_unit, prefix: true
end
