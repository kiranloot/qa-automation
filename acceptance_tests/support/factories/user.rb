require 'factory_girl'
require 'date'
require 'faker'
FactoryGirl.define do

  factory :user do
    first_name {"AutoTest" + Date.today.strftime("%b")}
    last_name {Date.today.strftime("%a") +  Date.today.strftime("%b") +
               Date.today.day.to_s + "At" + Time.now.to_f.to_s.reverse[0..6].delete(".")}
    password "qateam123"
    email { "_test_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    initialize_with {new($test)}
    country "United States"
    country_code "US"
    trait :registered do
      first_name "Registered"
      last_name "User"
      email { "_reg_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :admin do
      email {"admin@example.com"}
    end
    trait :alchemy do
      email {"cmsadmin@example.com"}
    end
    trait :canceled do
      first_name "Canceled"
      last_name "Subscription"
      email { "_cancelled_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_no_prior do
      first_name "ReggieNoPrior" + Date.today.strftime("%b") + Date.today.day.to_s
      email { "_regnoprior_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_with_active do
      first_name "Active"
      last_name "Subscription"
      email { "_regwsub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_with_active_last_month do
      first_name "Active Old"
      last_name "Subscription"
      email { "regwlastmonthsub_" + Faker::Internet.user_name + rand(999).to_s + "@fake.com" }
    end
    trait :registered_with_active_anime do
      first_name "ActiveAnime"
      last_name "Subscription"
      email { "_regwanimesub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_with_active_gaming do
      first_name "ActiveGaming"
      last_name "Subscription"
      email { "_regwgamessub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_with_active_firefly do
      first_name "ActiveFirefly"
      last_name "Subscription"
      email { "_regwfireflyssub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_with_active_level_up do
      first_name "Active"
      last_name "LUSubscription"
      email { "_regwlusub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :registered_with_active_pets do
      first_name "Active"
      last_name "LUSubscription"
      email { "_regwlusub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :one_month do
      registered_with_active
    end
    trait :anime_one_month do
      registered_with_active
    end
    trait :gaming_one_month do
      registered_with_active
    end
    trait :pets_one_month do
      registered_with_active
    end
    trait :wearable_one_month do
      registered_with_active
    end
    trait :tees_one_month do
      registered_with_active
    end
    trait :interational do
      first_name {"INTL" + first_name}
      email {"intl" + email}
    end
    trait :international_one_month do
      email {"_intlonemonth_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :california do
      first_name "California"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 California Ave"
      ship_city "Los Angeles"
      ship_zip "90031"
      email { "_ca_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "CA"
    end
    trait :washington do
      first_name "Washington"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Washington Ave"
      ship_city "Seattle"
      ship_state "WA"
      ship_zip "98004"
      email { "_wa_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "WA"
    end
    trait :new_york do
      first_name "NewYork"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 New York Ave"
      ship_city "New York"
      ship_state "NY"
      ship_zip "10001"
      email { "_ny_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "NY"
    end
    trait :texas do
      first_name "Texas"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Texas Ave"
      ship_city "Austin"
      ship_state "TX"
      ship_zip "78701"
      email { "_tx_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "TX"
    end
   trait :vermont do
      first_name "Vermont"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Vermont Ave"
      ship_city "Montpelier"
      ship_state "VT"
      ship_zip "05751"
      email { "_vt_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "VT"
    end
   trait :south_carolina do
      first_name "SouthCarolina"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 South Carolina Ave"
      ship_city "Columbia"
      ship_state "SC"
      ship_zip "29020"
      email { "_sc_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "SC"
    end
   trait :florida do
      first_name "Florida"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Florida ave"
      ship_city "miami"
      ship_state "FL"
      ship_zip "33124"
      email { "_fl_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "FL"
    end
   trait :pennsylvania do
      first_name "Pennsylvania"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Penn ave"
      ship_city "Harrisburg"
      ship_state "PA"
      ship_zip "15201"
      email { "_pa_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "PA"
    end
   trait :arizona do
      first_name "Arizona"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Arizona ave"
      ship_city "Phoenix"
      ship_state "AZ"
      ship_zip "85001"
      email { "_az_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      recurly_billing_state_code "AZ"
    end
    trait :denmark do
      first_name "Denmark"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Denmark Test"
      ship_city "Copenhagen"
      ship_state "Hovedstaden"
      ship_zip "1566"
      email { "_dk_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Denmark"
      country_code "DK"
    end
    trait :australia do
      first_name "Australia"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Australia Test"
      ship_city "Sydney"
      ship_state "Queensland"
      ship_zip "2148"
      email { "_au_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Australia"
      country_code "AU"
    end
    trait :austria do
      first_name "Austria"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Austria Test"
      ship_city "Salzburg"
      ship_state "Salzburg"
      ship_zip "5020"
      email { "_at_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Austria"
      country_code "AT"
    end
    trait :belgium do
      first_name "Belgium"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Belgium Test"
      ship_city "Antwerp"
      ship_state "Vlaams Gewest"
      ship_zip "2000"
      email { "_be_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Belgium"
      country_code "BE"
    end
    trait :canada do
      first_name "Canada"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Canada Test"
      ship_city "Toronto"
      ship_state "Ontario"
      ship_zip "M4C 1B5"
      email { "_ca_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Canada"
      country_code "CA"
      recurly_billing_state_code "ON"
    end
    trait :czechrepublic do
      first_name "Czech"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Czech Test"
      ship_city "Prague"
      ship_state "Olomoucký kraj"
      ship_zip "100 00"
      email { "_cz_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Czech Republic"
      country_code "CZ"
    end
    trait :finland do
      first_name "Finland"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Finland Test"
      ship_city "Helsinki"
      ship_state "Uusimaa"
      ship_zip "00100"
      email { "_fi_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Finland"
      country_code "FI"
    end
    trait :france do
      first_name "France"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 France Test"
      ship_city "Paris"
      ship_state "Île-de-France"
      ship_zip "75001"
      email { "_fr_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "France"
      country_code "FR"
    end
    trait :germany do
      first_name "Germany"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Germany Test"
      ship_city "Berlin"
      ship_state "Berlin"
      ship_zip "10405"
      email { "_de_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Germany"
      country_code "DE"
    end
    trait :hungary do
      first_name "Hungary"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Hungary Test"
      ship_city "Budapest"
      ship_state "Dunaújváros"
      ship_zip "1011"
      email { "_hu_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Hungary"
      country_code "HU"
    end
    trait :iceland do
      first_name "Iceland"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Iceland Test"
      ship_city "Reykjavík"
      ship_state "Reykjavík"
      ship_zip "101"
      email { "_is_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Iceland"
      country_code "IS"
    end
    trait :ireland do
      first_name "Ireland"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Ireland Test"
      ship_city "Dublin"
      ship_state "Leinster"
      ship_zip "KHG RT76"
      email { "_ie_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Ireland"
      country_code "IE"
    end
    trait :israel do
      first_name "Israel"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Israel Test"
      ship_city "Jerusalem"
      ship_state "Tel-Aviv"
      ship_zip "61071"
      email { "_il_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Israel"
      country_code "IL"
    end
    trait :italy do
      first_name "Italy"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Italy Test"
      ship_city "Naples"
      ship_state "Campania"
      ship_zip "80079"
      email { "_it_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Italy"
      country_code "IT"
    end
    trait :luxembourg do
      first_name "Luxembourg"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Luxembourg Test"
      ship_city "Luxembourg"
      ship_state "Luxembourg"
      ship_zip "9011"
      email { "_lu_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Luxembourg"
      country_code "LU"
    end
    trait :netherlands do
      first_name "Netherlands"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Nethernlands Test"
      ship_city "Amsterdam"
      ship_state "Noord-Holland"
      ship_zip "1011"
      email { "_nl_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Netherlands"
      country_code "NL"
    end
    trait :newzealand do
      first_name "NewZealand"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 New Zealand Test"
      ship_city "Auckland"
      ship_state "North Island"
      ship_zip "0632"
      email { "_nz_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "New Zealand"
      country_code "NZ"
    end
    trait :norway do
      first_name "Norway"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Norway Test"
      ship_city "Oslo"
      ship_state "Oslo"
      ship_zip "0001"
      email { "_no_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Norway"
      country_code "NO"
    end
    trait :poland do
      first_name "Poland"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Poland Test"
      ship_city "Warsaw"
      ship_state "Mazowieckie"
      ship_zip "00-001"
      email { "_pl_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Poland"
      country_code "PL"
    end
    trait :portugal do
      first_name "Portugal"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Portugal Test"
      ship_city "Lisbon"
      ship_state "Lisboa"
      ship_zip "1000"
      email { "_pt_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Portugal"
      country_code "PT"
    end
    trait :singapore do
      first_name "Singapore"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Singapore Test"
      ship_city "Adam Park"
      ship_state "Central Singapore"
      ship_zip "308215"
      email { "_sg_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Singapore"
      country_code "SG"
    end
    trait :southafrica do
      first_name "South Africa"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 South Africa Test"
      ship_city "Johannesburg"
      ship_state "Gauteng"
      ship_zip "2001"
      email { "_za_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "South Africa"
      country_code "ZA"
    end
    trait :spain do
      first_name "Spain"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Spain Test"
      ship_city "Madrid"
      ship_state "Madrid, Comunidad de"
      ship_zip "28000"
      email { "_es_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Spain"
      country_code "ES"
    end
    trait :sweden do
      first_name "Sweden"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Sweden Test"
      ship_city "Stockholm"
      ship_state "Gotlands län"
      ship_zip "110 00"
      email { "_se_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Sweden"
      country_code "SE"
    end
    trait :switzerland do
      first_name "Switzerland"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Switzerland Test"
      ship_city "Zurich"
      ship_state "Zürich"
      ship_zip "8000"
      email { "_ch_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Switzerland"
      country_code "CH"
    end
    trait :unitedkingdom do
      first_name "United Kingdom"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 United Kingdom Test"
      ship_city "London"
      ship_state "England and Wales"
      ship_zip "WC1H 8JJ"
      email { "_gb_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "United Kingdom"
      country_code "GB"
    end
    trait :mexico do
      first_name "Mexico"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "Calle Falso 1234"
      ship_city "Mirador"
      ship_state "Chihuahua"
      ship_zip "77520"
      email { "_mx_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Mexico"
      country_code "MX"
    end
    trait :argentina do
      first_name "Argentina"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "Calle Falsa 1234"
      ship_city "San Salvador de Jujuy"
      ship_state "Jujuy"
      ship_zip "77520"
      email { "_ar_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Argentina"
      country_code "AR"
    end
    trait :chile do
      first_name "Chile"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "Calle Falsa 1234"
      ship_city "Molina"
      ship_state "Maule"
      ship_zip "07304"
      email { "_cl_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Chile"
      country_code "CL"
    end
    trait :colombia do
      first_name "Colombia"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "Calle Falsa 1234"
      ship_city "Chaparral"
      ship_state "Tolima"
      ship_zip "73168"
      email { "_co_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Colombia"
      country_code "CO"
    end
    trait :southkorea do
      first_name "South Korea"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "123 가짜 거리"
      ship_city "Dongjak"
      ship_state "Seoul Teugbyeolsi"
      ship_zip "11200"
      email { "_kr_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "South Korea"
      country_code "KR"
    end
    trait :turkey do
      first_name "Turkey"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "123 Sahte Sokak"
      ship_city "Çilimli"
      ship_state "Düzce"
      ship_zip "1905"
      email { "_tr_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Turkey"
      country_code "TR"
    end
    trait :japan do
      first_name "Japan"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "123 フェイク・ストリート"
      ship_city "Tokyo"
      ship_state "Tokyo"
      ship_zip "100-0001"
      email { "_jp_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Japan"
      country_code "JP"
    end
    trait :brazil do
      first_name "Brazil"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "123 Rua Falso"
      ship_city "Rio"
      ship_state "Rio"
      ship_zip "10001"
      email { "_br_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
      country "Brazil"
      country_code "BR"
    end
    trait :multi_use_fixed_promo do
      coupon_code  {$test.test_data["promos"]["multi_use"]}
    end
    trait :one_time_use_percentage_promo do
      coupon_code  {$test.test_data["promos"]["multi_use"]}
    end
    trait :registered_with_active_and_tracking do
      heroku = HerokuAPI.new
      email { heroku.create_user_with_acive_sub_and_tracking_info }
      password "password"
      subscription {FactoryGirl.build(:subscription)}
    end
  end

 end
