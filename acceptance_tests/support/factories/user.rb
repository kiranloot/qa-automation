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
    trait :registered do
      first_name "Registered"
      last_name "User"
      email { "_reg_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :admin do
      email {$env_base_url.include?("goliath") ? "admin@example.com" : "chris.lee@lootcrate.com"}
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
    end
    trait :denmark do
      first_name "Denmark"
      last_name {Date.today.strftime("%b") + Date.today.day.to_s}
      ship_street "1234 Denmark Test"
      ship_city "Copenhagen"
      ship_state "Hovedstaden"
      ship_zip "1566"
      email { "_dk_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com" }
    end
    trait :multi_use_promo do
      coupon_code  {$test.test_data["promos"]["multi_use"]}
    end
  end

 end
