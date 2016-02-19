require 'factory_girl'

FactoryGirl.define do

  factory :address do
    bill_street "4321 Fake Blvd"
    bill_street_2 ""
    bill_city "New York"
    bill_zip "10022"
    bill_state "NY"

    trait :US do
    end

    trait :DK do
      bill_street "4321 Fake Denmark"
      bill_city "Herning"
      bill_zip "7400"
      bill_state "Midtjylland"
    end

    trait :AU do
      bill_street "4321 Australia Blvd"
      bill_city "Smoky Bay"
      bill_zip "5680"
      bill_state "South Australia"
    end

    trait :AT do
      bill_street "4321 Austria Blvd"
      bill_city "Villach"
      bill_zip "9500"
      bill_state "Kärnten"
    end

    trait :BE do
      bill_street "4321 Belgium Blvd"
      bill_city "Bruxelles"
      bill_zip "1000"
      bill_state "Vlaams Gewest"
    end

    trait :CA do
      bill_street "4321 Canada Blvd"
      bill_city "Montreal"
      bill_zip "H4B 5G0"
      bill_state "Quebec"
    end

    trait :CZ do
      bill_street "4321 Czech Blvd"
      bill_city "Dalovice"
      bill_zip "362 63"
      bill_state "Karlovarský kraj"
    end

    trait :FI do
      bill_street "4321 Finland Blvd"
      bill_city "Paltamo"
      bill_zip "88300"
      bill_state "Kainuu"
    end

    trait :FR do
      bill_street "4321 France Blvd"
      bill_city "Nomeny"
      bill_zip "54610"
      bill_state "Lorraine"
    end

    trait :DE do
      bill_street "4321 Germany Blvd"
      bill_city "Hamburg"
      bill_zip "20457"
      bill_state "Hamburg"
    end

    trait :HU do
      bill_street "4321 Hungary Blvd"
      bill_city "Békéscsaba"
      bill_zip "5600"
      bill_state "Békés"
    end

    trait :IS do
      bill_street "4321 Iceland Blvd"
      bill_city "Hella"
      bill_zip "850"
      bill_state "Suðurland"
    end

    trait :IE do
      bill_street "4321 Ireland Blvd"
      bill_city "Belfast"
      bill_zip "BT7 1GY"
      bill_state "Ulster"
    end

    trait :IL do
      bill_street "4321 Israel Blvd"
      bill_city "Haifa"
      bill_zip "31000"
      bill_state "Hefa"
    end

    trait :IT do
      bill_street "4321 Italy Blvd"
      bill_city "Cosenza"
      bill_zip "87100"
      bill_state "Calabria"
    end

    trait :LU do
      bill_street "4321 Luxembourg Blvd"
      bill_city "Diekirch"
      bill_zip "9240"
      bill_state "Diekirch"
    end

    trait :NL do
      bill_street "4321 Netherlands Blvd"
      bill_city "Willemstad"
      bill_zip "0000"
      bill_state "Curaçao"
    end

    trait :NZ do
      bill_street "4321 New Zealand Blvd"
      bill_city "Christchurch"
      bill_zip "8011"
      bill_state "South Island"
    end

    trait :NO do
      bill_street "4321 Norway Blvd"
      bill_city "Hamar"
      bill_zip "2321"
      bill_state "Hedmark"
    end

    trait :PL do
      bill_street "4321 Poland Blvd"
      bill_city "Bialystok"
      bill_zip "15-089"
      bill_state "Podlaskie"
    end

    trait :PT do
      bill_street "4321 Portugal Blvd"
      bill_city "Tenões"
      bill_zip "4715-261"
      bill_state "Braga"
    end

    trait :ZA do
      bill_street "4321 South Africa Blvd"
      bill_city "Bloemfontein"
      bill_zip "9301"
      bill_state "Free State"
    end

    trait :ES do
      bill_street "4321 Spain Blvd"
      bill_city "Barcelona"
      bill_zip "08013"
      bill_state "Catalunya"
    end

    trait :SE do
      bill_street "4321 Sweden Blvd"
      bill_city "Hemse"
      bill_zip "623 50"
      bill_state "Gotlands län"
    end

    trait :CH do
      bill_street "4321 Switzerland Blvd"
      bill_city "Brugg"
      bill_zip "5200"
      bill_state "Aargau"
    end

    trait :GB do
      bill_street "4321 United Kingdom Blvd"
      bill_city "Cardiff"
      bill_zip "CF10 4GA"
      bill_state "Cardiff;Caerdydd"
    end

    trait :MX do
      bill_street "4321 Mexico Blvd"
      bill_city "Tuxtla Gutiérrez"
      bill_zip "29043"
      bill_state "Chiapas"
    end

    trait :AR do
      bill_street "4321 Argentina Blvd"
      bill_city "Buenos Aires"
      bill_zip "1084"
      bill_state "Buenos Aires"
    end

    trait :CL do
      bill_street "4321 Chile Blvd"
      bill_city "Antofagasta"
      bill_zip "4520"
      bill_state "Antofagasta"
    end

    trait :CO do
      bill_street "4321 Colombia Blvd"
      bill_city "Medellín"
      bill_zip "050028"
      bill_state "Antioquia"
    end

    trait :KR do
      bill_street "4321 South Korea Blvd"
      bill_city "Chuncheon"
      bill_zip "32010"
      bill_state "Gang'weondo"
    end

    trait :TR do
      bill_street "4321 Turkey Blvd"
      bill_city "Karabük Merkez"
      bill_zip "78100"
      bill_state "Karabük"
    end
  end
end
