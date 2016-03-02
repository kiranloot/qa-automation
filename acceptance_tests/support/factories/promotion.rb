require 'factory_girl'

FactoryGirl.define do

  factory :promotion do
    one_time_use false
    trigger 'SIGNUP'
    adjustment_type 'Fixed'
    adjustment_amount 10

    trait :trigger_reactivation do
      trigger 'REACTIVATION'
    end

    trait :trigger_upgrade do
      trigger 'UPGRADE'
    end

    trait :one_time_use do
      one_time_use true
    end

    trait :percent do
      adjustment_type 'Percentage'
    end

    trait :fixed do
      #default value
    end
  end
end
