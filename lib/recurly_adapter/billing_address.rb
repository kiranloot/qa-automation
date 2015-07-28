module RecurlyAdapter
  class BillingAddress
    def self.to_hash(billing_address)
      {
        first_name:         billing_address.first_name,
        last_name:          billing_address.last_name,
        address1:           billing_address.line_1,
        address2:           billing_address.line_2,
        city:               billing_address.city,
        state:              billing_address.state,
        zip:                billing_address.zip,
        country:            billing_address.country
      }.reject { |key, value| value.nil? }
    end
  end
end
