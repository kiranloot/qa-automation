# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  line_1          :string(255)
#  line_2          :string(255)
#  state           :string(255)
#  city            :string(255)
#  zip             :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_name      :string(255)
#  last_name       :string(255)
#  subscription_id :integer
#

FactoryGirl.define do
  factory :billing_address do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    line_1      { Faker::Address.street_address }
    line_2      { Faker::Address.secondary_address }
    city        { Faker::Address.city }
    state       { Faker::Address.state_abbr }
    zip         { Faker::Address.zip }
    country     "US"
  end

  factory :bad_billing_address, class: BillingAddress do
    first_name "The"
    last_name  "Purp"
  end
end
