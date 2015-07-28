FactoryGirl.define do
  factory :product do
    name "tie"
    brand "blacktiegeek"
    max_inventory_count 10
  end

  trait :with_plan_3_months do
    after(:create) do |product|
      product.plans << create(:plan_3_months)
    end
  end

  trait :with_plan_3_months_intl do
    after(:create) { product.plans << create(:plan_3_months_intl) }
  end
end
