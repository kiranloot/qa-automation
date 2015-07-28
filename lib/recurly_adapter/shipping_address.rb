module RecurlyAdapter
  class ShippingAddress
    def self.to_hash(shipping_address)
      {
        first_name: shipping_address.first_name,
        last_name:  shipping_address.last_name,
        address:    {
          address1: shipping_address.line_1,
          address2: shipping_address.line_2,
          city:     shipping_address.city,
          state:    shipping_address.state,
          country:  shipping_address.country,
          zip:      shipping_address.zip
        }
      }
    end
  end
end
