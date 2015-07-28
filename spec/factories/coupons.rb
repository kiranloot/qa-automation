# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    promotion
    code "coupon1"
    usage_count 0
  end
end
