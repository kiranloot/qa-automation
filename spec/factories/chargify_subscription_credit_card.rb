FactoryGirl.define do
  factory :chargify_subscription_credit_card, class: Chargify::Subscription::CreditCard do
    billing_city { Faker::Address.city }
    billing_country 'US'
    billing_state 'CA'
    billing_zip '90104'
    card_type 'bogus'
    current_vault 'bogus'
    customer_id 7425292
    customer_vault_token nil
    expiration_month 1
    expiration_year 2039
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    masked_card_number 'XXXX-XXXX-XXXX-1'
    vault_token 1
    payment_type 'credit_card'
  end
end
