# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promotion do
    starts_at Date.today - 1
    ends_at Date.today + 10.days
    description Faker::Lorem.paragraph
    name Faker::App.name
    one_time_use false
    adjustment_amount 0.00
    adjustment_type 'Fixed'
    trigger_event 'SIGNUP'
    sequence(:coupon_prefix) { |n| "b_-+#{ n }" }
  end
end
