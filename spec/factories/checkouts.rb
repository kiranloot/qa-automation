# # Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :checkout do
    quantity 1
    chargify_coupon_code "MyString"
    user
    plan
    shirt_size 'M XL'
    coupon_code 'coupon_code'

    trait :with_billing_info do
      billing_address_line_1 'ATTN: Testers'
      billing_address_line_2 '3401 Pasadena Ave'
      billing_address_city 'Los Angeles'
      billing_address_state 'CA'
      billing_address_zip '90031'
      billing_address_country 'US'
      billing_address_full_name 'test case'
    end

    trait :with_shipping_info do
      shipping_address_line_1 'ATTN: Testers'
      shipping_address_line_2 '3401 Pasadena Ave'
      shipping_address_city 'Los Angeles'
      shipping_address_state 'CA'
      shipping_address_zip '90031'
      shipping_address_country 'US'
      shipping_address_first_name 'test'
      shipping_address_last_name 'case'
    end

    trait :with_chargify_subscription_id do
      chargify_subscription_id '7442643'
    end

    trait :with_credit_card_info do
      credit_card_expiration_date { Date.today+1.month }
      credit_card_cvv '123'
      credit_card_number '4111111111111111'
    end

  end

end
