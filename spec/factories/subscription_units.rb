FactoryGirl.define do
  factory :subscription_unit do
    subscription_period nil
    shipping_address
    tracking_number { Faker::Code.ean }
    service_code 'usps_first_class_mail'
    month_year { Date.today.strftime("%^b%Y") }
  end
end
