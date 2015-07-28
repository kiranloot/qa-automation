# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promo_conversion do
    product_id 1
    product_type "MyString"
    product_initial_cost "9.99"
    product_discounted_cost "9.99"
  end
end
