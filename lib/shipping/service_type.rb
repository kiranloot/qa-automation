module Shipping
  module ServiceType
    def self.for_address(address)
      country = address.try(:country)

      if country == 'US'
        if %w(AA AE AK AP GU HI PR VI).include? address.state
          nil
        else
          'FedEx'
        end
      elsif %w(CA NO NZ).include? country
        'IPA'
      elsif %w(AU GB DE DK IE SE NL FI FR).include? country
        'CI'
      else
        nil
      end
    end
  end
end
