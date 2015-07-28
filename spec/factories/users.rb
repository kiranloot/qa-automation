FactoryGirl.define do
  factory :batman, class: User do
    email "batman@brucewayne.com"
    password 'password'
    password_confirmation 'password'
  end

  factory :user do
    sequence(:email) { |n| Faker::Internet.email("test#{n}") }
    password 'please'
    password_confirmation 'please'

    factory :user_with_one_subscription do

      transient do
        subscription_count 1
      end

      after(:create) do |user, evaluator|
        create_list(:subscription, evaluator.subscription_count, user: user)
      end
    end

    factory :user_with_multiple_subscriptions do

      transient do
        subscription_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:subscription, evaluator.subscription_count, user: user)
      end
    end

    factory :user_with_incorrect_chargify_mapping do
      transient do
        customer_count 1
        subscription_count 2
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:chargify_customer_account, evaluator.customer_count, user: user)
        FactoryGirl.create_list(:subscription, evaluator.subscription_count, user: user)
      end
    end

    factory :with_facebook_account do
      provider 'facebook'
      uid '123'
    end
  end
end
