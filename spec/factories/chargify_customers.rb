# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chargify_customer do
    chargify_customer_id 1
  end

  factory :chargify_customer_account, class: ChargifyCustomer do
    chargify_customer_id { Faker::Number.number(5) }
    initialize_with { ChargifyCustomer.find_or_create_by(chargify_customer_id: chargify_customer_id)}
    user
  end
end
