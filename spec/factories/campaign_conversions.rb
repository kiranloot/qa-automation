# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign_conversion do
    utm_source "MyString"
    utm_campaign "MyString"
    utm_medium "MyString"
    user nil
  end
end
