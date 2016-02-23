require 'factory_girl'

FactoryGirl.define do

  factory :address do
    street "4321 Fake Blvd"
    street_2 ""
    city "New York"
    zip "10022"
    state "NY"

    trait :US do
    end

    trait :DK do
      street "4321 Fake Denmark"
      city "Herning"
      zip "7400"
      state "Midtjylland"
    end

    trait :AU do
      street "4321 Australia Blvd"
      city "Smoky Bay"
      zip "5680"
      state "South Australia"
    end

    trait :AT do
      street "4321 Austria Blvd"
      city "Villach"
      zip "9500"
      state "Kärnten"
    end

    trait :BE do
      street "4321 Belgium Blvd"
      city "Bruxelles"
      zip "1000"
      state "Vlaams Gewest"
    end

    trait :CA do
      street "4321 Canada Blvd"
      city "Montreal"
      zip "H4B 5G0"
      state "Quebec"
    end

    trait :CZ do
      street "4321 Czech Blvd"
      city "Dalovice"
      zip "362 63"
      state "Karlovarský kraj"
    end

    trait :FI do
      street "4321 Finland Blvd"
      city "Paltamo"
      zip "88300"
      state "Kainuu"
    end

    trait :FR do
      street "4321 France Blvd"
      city "Nomeny"
      zip "54610"
      state "Lorraine"
    end

    trait :DE do
      street "4321 Germany Blvd"
      city "Hamburg"
      zip "20457"
      state "Hamburg"
    end

    trait :HU do
      street "4321 Hungary Blvd"
      city "Békéscsaba"
      zip "5600"
      state "Békés"
    end

    trait :IS do
      street "4321 Iceland Blvd"
      city "Hella"
      zip "850"
      state "Suðurland"
    end

    trait :IE do
      street "4321 Ireland Blvd"
      city "Belfast"
      zip "BT7 1GY"
      state "Ulster"
    end

    trait :IL do
      street "4321 Israel Blvd"
      city "Haifa"
      zip "31000"
      state "Hefa"
    end

    trait :IT do
      street "4321 Italy Blvd"
      city "Cosenza"
      zip "87100"
      state "Calabria"
    end

    trait :LU do
      street "4321 Luxembourg Blvd"
      city "Diekirch"
      zip "9240"
      state "Diekirch"
    end

    trait :NL do
      street "4321 Netherlands Blvd"
      city "Willemstad"
      zip "0000"
      state "Curaçao"
    end

    trait :NZ do
      street "4321 New Zealand Blvd"
      city "Christchurch"
      zip "8011"
      state "South Island"
    end

    trait :NO do
      street "4321 Norway Blvd"
      city "Hamar"
      zip "2321"
      state "Hedmark"
    end

    trait :PL do
      street "4321 Poland Blvd"
      city "Bialystok"
      zip "15-089"
      state "Podlaskie"
    end

    trait :PT do
      street "4321 Portugal Blvd"
      city "Tenões"
      zip "4715-261"
      state "Braga"
    end

    trait :ZA do
      street "4321 South Africa Blvd"
      city "Bloemfontein"
      zip "9301"
      state "Free State"
    end

    trait :ES do
      street "4321 Spain Blvd"
      city "Barcelona"
      zip "08013"
      state "Catalunya"
    end

    trait :SE do
      street "4321 Sweden Blvd"
      city "Hemse"
      zip "623 50"
      state "Gotlands län"
    end

    trait :CH do
      street "4321 Switzerland Blvd"
      city "Brugg"
      zip "5200"
      state "Aargau"
    end

    trait :GB do
      street "4321 United Kingdom Blvd"
      city "Cardiff"
      zip "CF10 4GA"
      state "Cardiff;Caerdydd"
    end

    trait :MX do
      street "4321 Mexico Blvd"
      city "Tuxtla Gutiérrez"
      zip "29043"
      state "Chiapas"
    end

    trait :AR do
      street "4321 Argentina Blvd"
      city "Buenos Aires"
      zip "1084"
      state "Buenos Aires"
    end

    trait :CL do
      street "4321 Chile Blvd"
      city "Antofagasta"
      zip "4520"
      state "Antofagasta"
    end

    trait :CO do
      street "4321 Colombia Blvd"
      city "Medellín"
      zip "050028"
      state "Antioquia"
    end

    trait :KR do
      street "4321 South Korea Blvd"
      city "Chuncheon"
      zip "32010"
      state "Gang'weondo"
    end

    trait :TR do
      street "4321 Turkey Blvd"
      city "Karabük Merkez"
      zip "78100"
      state "Karabük"
    end
  end
end
