class TaxRetriever
  attr_reader :address_info
  def initialize(address_info, options = {})
    @address_info = address_info.to_s
    @amount       = options[:amount] || 0
  end

  def get_tax_details
    begin
      build_tax_details
    rescue StandardError
      build_default_tax_details
    end
  end

  private
    def tax_details
      @tax_details ||= avatax_service.estimate(coordinates_hash, amount.dollars)
    end

    def build_tax_details
      {
        rate: tax_rate,
        region: tax_region,
        tax_amount: tax_amount.dollars,
        tax_amount_in_cents: tax_amount.cents,
        total_amount: total_amount.dollars,
        total_amount_in_cents: total_amount.cents
      }
    end

    def build_default_tax_details
      {
        rate: 0,
        region: 'N/A',
        tax_amount: 0,
        tax_amount_in_cents: 0,
        total_amount: amount.dollars,
        total_amount_in_cents: amount.cents
      }
    end

    def coordinates_hash
      {
        latitude: coordinates[0],
        longitude: coordinates[1]
      }
    end

    def coordinates
      @coordinates ||= ::Geocoder.coordinates(address_info)
    end

    def avatax_service
      @avatax_service ||= ::AvaTax::TaxService.new
    end

    def tax_rate
      tax_details['Rate']
    end

    def tax_region
      tax_details['TaxDetails'][0]['Region']
    end

    def amount
      @amount.to_money
    end

    def tax_amount
      tax_details['Tax'].to_money
    end

    def dollars_to_cents(dollars)
      (dollars.to_f * 100).to_i
    end

    def total_amount
      amount + tax_amount
    end
end
