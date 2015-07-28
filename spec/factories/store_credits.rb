# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_credit do
    referrer_user_email 'test@mailinator.com'
  end
end
