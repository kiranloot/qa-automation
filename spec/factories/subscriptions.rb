FactoryGirl.define do
  factory :subscription do
    looter_name { Faker::Internet.user_name }
    shirt_size  { ["M S", "M M", "M L", "M XL"].sample }
    customer_id { Faker::Number.number(5) }
    chargify_subscription_id { Faker::Number.number(5) }
    recurly_subscription_id { Faker::Number.number(5) }
    subscription_status 'active'
    braintree true

    user
    billing_address
    shipping_address
    creation_date { Time.now }
    plan
    last_4 1111
    next_assessment_at { DateTime.now + 1.month }
    recurly_account_id { Faker::Number.number(5) }

    after(:create) do |s|
      FactoryGirl.create(:chargify_customer_account,
        chargify_customer_id: s.customer_id,
        user: s.user,
        braintree: s.braintree
      )
    end

    factory :invalid_subscription do
      shirt_size nil
    end

    factory :active_subscription do
      subscription_status 'active'
    end

    factory :canceled_subscription do
      subscription_status 'canceled'
    end
  end

  factory :subscription_without_period, class: Subscription do
    looter_name { Faker::Internet.user_name }
    shirt_size  { ["M S", "M M", "M L", "M XL"].sample }
    customer_id { Faker::Number.number(5) }
    chargify_subscription_id { Faker::Number.number(5) }
    subscription_status 'active'
    braintree true

    user
    billing_address
    shipping_address
    creation_date { Time.now }
    plan
    last_4 1111
    next_assessment_at { DateTime.now + 1.month }
  end

  factory :bad_subscription, class: Subscription do
    shirt_size "XXX"
  end
end
