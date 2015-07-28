FactoryGirl.define do
  factory :shipping_address do
    first_name      "El"
    last_name       "Diablo"
    line_1          "666 Stix Rvr"
    city            "Hell"
    state           "CA"
    zip             "90025"
    country         "US"

    factory :shipping_address_not_in_CA do
      first_name      "El"
      last_name       "Diablo"
      line_1          "666 Stix Rvr"
      city            "Hell"
      state           "NV"
      zip             "90025"
      country         "US"
    end

    factory :shipping_address_in_CA do
      first_name      "El"
      last_name       "Diablo"
      line_1          "666 Stix Rvr"
      city            "Hell"
      state           "CA"
      zip             "90025"
      country         "US"
    end

    factory :random_shipping_address do
      first_name  { Faker::Name.first_name }
      last_name   { Faker::Name.last_name }
      line_1      { Faker::Address.street_address }
      line_2      { Faker::Address.secondary_address }
      city        { Faker::Address.city }
      state       { Faker::Address.state_abbr }
      zip         { Faker::Address.zip }
      country     "US"
    end
  end

  factory :bad_shipping_address, class: ShippingAddress do
    first_name "The"
    last_name  "Purp"
  end
end
