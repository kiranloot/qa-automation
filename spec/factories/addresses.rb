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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    line_1  "123 Street"
    state   "CA"
    city    "Los Angeles"
    zip     "90025"
    country "US"
  end
end
