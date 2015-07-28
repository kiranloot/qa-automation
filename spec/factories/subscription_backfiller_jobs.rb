FactoryGirl.define do
  factory :subscription_backfiller_job do
    account_code SecureRandom.uuid
    plan_code SecureRandom.uuid
    starts_at "2015-06-01 17:54:22"
    next_assessment_at "2015-06-01 17:54:22"
    balance 9.99
  end

end
