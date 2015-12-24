require 'factory_girl'
require 'date'
require 'faker'
FactoryGirl.define do

  factory :user do
    first_name {"AutoTest" + Date.today.strftime("%b")}
    last_name {Date.today.strftime("%a") +  Date.today.strftime("%b") +
               Date.today.day.to_s + "At" + Time.now.to_f.to_s.reverse[0..6].delete(".")}
    password "password"
    email { "_test_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    initialize_with {new($test)}
    country_code "US"
    trait :registered do
      first_name "Registered"
      last_name "User"
      email { "_reg_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :admin do
      email {$env_base_url.match(/goliath|localhost|load-test/) ? "admin@example.com" : "chris.lee@lootcrate.com"}
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
    trait :registered_with_active_level_up do
      first_name "Active"
      last_name "LUSubscription"
      email { "_regwlusub_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :one_month do 
      registered_with_active
    end
    trait :interational do
      first_name {"INTL" + first_name}
      email {"intl" + email}
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
    trait :denmark do
      first_name "Denmark"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Denmark Test"
      ship_city "Copenhagen"
      ship_state "Hovedstaden"
      ship_zip "1566"
      email { "_dk_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
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
      country_code "CA"
      recurly_billing_state_code "ON"
    end
    trait :czech do
      first_name "Czech"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Czech Test"
      ship_city "Prague"
      ship_state "Olomoucký kraj"
      ship_zip "100 00"
      email { "_cz_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
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
      country_code "IE"
    end
    trait :israel do
      first_name "israel"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Israel Test"
      ship_city "Jerusalem"
      ship_state "Tel-Aviv"
      ship_zip "61071"
      email { "_il_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
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
      country_code "SG"
    end
    trait :southafrica do
      first_name "SouthAfrica"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 South Africa Test"
      ship_city "Johannesburg"
      ship_state "Gauteng"
      ship_zip "2001"
      email { "_za_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
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
      country_code "GB"
    end
    trait :multi_use_promo do
      coupon_code  {$test.test_data["promos"]["multi_use"]}
    end
    trait :one_time_use_promo do
      coupon_code  {$test.test_data["promos"]["multi_use"]}
    end
    trait :registered_with_active_and_tracking do
      heroku = HerokuAPI.new
      email { heroku.create_user_with_acive_sub_and_tracking_info }
    end
  end

 end
