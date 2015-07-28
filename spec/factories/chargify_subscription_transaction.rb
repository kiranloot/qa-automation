FactoryGirl.define do
  factory :chargify_subscription_transaction, class: ::Chargify::Subscription::Transaction do
    transaction_type 'payment'
    success true
    amount_in_cents {Faker::Number.number(3)}

    factory :chargify_subscription_transaction_refund do
      transaction_type 'refund'
    end
  end

  factory :chargify_subscription_transaction_coupon, class: ::Chargify::Subscription::Transaction do
    transaction_type 'adjustment'
    kind 'coupon'
    success true
    amount_in_cents {Faker::Number.number(-3)}
  end
end