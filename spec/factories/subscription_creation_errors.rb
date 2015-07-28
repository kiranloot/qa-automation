# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription_creation_error do
    user_id 1
    user_email "MyString"
    chargify_subscription_id 1
  end
end
