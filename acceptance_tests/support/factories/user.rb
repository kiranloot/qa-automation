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
      ship_state "Antwerp"
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
