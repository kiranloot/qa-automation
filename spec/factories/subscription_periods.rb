FactoryGirl.define do
  factory :subscription_period do
    subscription nil

    factory :active_subscription_period do
      status 'active'
      term_length 1
      start_date DateTime.now
      expected_end_date (DateTime.now + 1.month)
      creation_reason 'subscription_created'
    end

    factory :canceled_subscription_period do
      status 'canceled'
      term_length 1
      start_date DateTime.now - 1.month
      expected_end_date DateTime.now - 1.minute
      creation_reason 'subscription_created'
    end

    factory :dunning_subscription_period do
      status 'past_due'
      term_length 1
      start_date DateTime.now
      expected_end_date (DateTime.now + 1.month)
      creation_reason 'subscription_created'
    end
  end

end
