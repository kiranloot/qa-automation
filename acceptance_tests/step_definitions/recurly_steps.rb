#Recurly steps
Then(/^recurly should have a matching subscription$/) do
  $test.recurly.verify_subscription_type
end

Then(/^recurly should have a matching international subscription$/) do
  $test.recurly.verify_subscription_type($test.user.country_code)
end

Then(/^recurly should now have a (.*) month subscription plan$/) do |months|
  $test.recurly.verify_subscription_upgrade (months)
end
       
Then(/^recurly should have a (.*) month subscription for the (.*) crate$/) do |months, product|
  $test.recurly.verify_level_up_subscription(months,product)
end

Then(/^the recurly subscription should be (.*)$/) do |status|
  $test.recurly.verify_status (status)
end

Then(/^the recurly billing address should be updated$/) do
  $test.recurly.verify_billing_address
end

Then(/^the recurly shipping address should be updated$/) do
  $test.recurly.verify_shipping_address
end

Then(/^the recurly billing address should have no state$/)do
  $test.recurly.verify_billing_address_has_no_state
end

Then(/^the recurly billing address should have the correct state$/) do
  $test.recurly.verify_billing_address_has_state($test.user.recurly_billing_state_code)
end

Then(/^the recurly account's last transaction should have tax calculated$/) do
  expect($test.recurly.get_last_invoice_for_account.tax_in_cents).to be_truthy
end

Then(/^the recurly subscription should have the correct rebill date$/)do
  date_hash = $test.calculate_rebill_date
  month_int = Date::MONTHNAMES.index(date_hash['month'])
  date_hash['month'] = month_int < 10 ? "0" + month_int.to_s : month_int.to_s
  recurly_rebill_date = $test.recurly.get_rebill_date.new_offset(-8.0/24).to_s
  recurly_hash = {}
  recurly_hash['year'], recurly_hash['month'], recurly_hash['day'] = recurly_rebill_date.scan(/\d+/)
  ['year','month','day'].each do |key|
    expect(recurly_hash[key]).to eq date_hash[key]
  end
end
