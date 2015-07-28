require 'active_model/serializer'

module Wombat
  class SubscriptionShipmentSerializer < ActiveModel::Serializer
    attributes :id, :order_id, :email, :cost, :status, :stock_location,
               :tracking, :placed_on, :shipped_at, :totals,
               :updated_at, :channel, :items, :bill_to, :ship_to, :shipping_address

    def id
      object.shipstation_order_number
    end

    def order_id
      object.shipstation_order_number
    end

    def tracking
      object.tracking_number
    end

    def email
      object.subscription.user.email rescue "looter@lootcrate.com"
    end

    def channel
      "spree"
    end

    def cost
      0.0
    end

    def bill_to
      ship_to
    end

    def shipping_address
      ship_to
    end

    def ship_to
      ShippingAddressSerializer.new(object.shipping_address, root: false)
    end

    def shipped_at
      nil
    end

    def status
      # we'll need to revisit this
      object.subscription.is_active? ? 'pending' : 'canceled'
    end

    def stock_location
      "default"
    end

    def placed_on
      ''
    end

    def totals
      {:item => 0.0, adjustment: 0.0, tax: 0.0, shipping: 0.0, payment: 0.0, order: 0.0}
    end

    def updated_at
      object.updated_at.iso8601
    end

    def items
      [{:product_id => object.shipstation_item_name, :name => object.shipstation_item_name, :quantity => 1, :price => 0.0}]
    end
  end
end
