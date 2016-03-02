#WHENS
When(/^the recurly rebill date is pushed (.*) minute into the future$/) do |minutes|
  $test.user.recurly_rebill_date = $test.recurly.update_next_renewal_date(minutes.to_i)
end

When(/^the recurly credit card information is modified to be declined$/) do
  $test.recurly.change_account_cc_to('4000-0000-0000-0341')
end

When /the user notes the recurly rebill date$/ do
  @original_rebill = $test.recurly.get_rebill_date
end

#THENS
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
  #should probably move this into a function
  date_hash = $test.calculate_rebill_date
  month_int = Date::MONTHNAMES.index(date_hash['month'])
  date_hash['month'] = month_int < 10 ? "0" + month_int.to_s : month_int.to_s
  recurly_rebill_date = $test.recurly.get_rebill_date.to_s
  recurly_hash = {}
  recurly_hash['year'], recurly_hash['month'], recurly_hash['day'] = recurly_rebill_date.scan(/\d+/)
  ['year','month','day'].each do |key|
    expect(recurly_hash[key]).to eq date_hash[key]
  end
end

Then(/^the recurly subscription data is fully validated$/)do
  $test.recurly.verify_subscription_type($test.user.country_code)
  $test.recurly.verify_full_name
  $test.recurly.verify_cc_info
  $test.recurly.verify_billing_address
  $test.recurly.verify_rebill_date
end

Then(/^the recurly coupon is correctly created$/) do
  coupon = $test.recurly.get_coupon_info($test.user.promo.base_coupon_code)
  expect(coupon.state).to eq("redeemable")
  expect(coupon.single_use).to be true
  expect(coupon.redeem_by_date).to be nil
  expect(coupon.plan_codes).to be_empty
  if $test.user.promo.adjustment_type == 'Fixed'
    expect(coupon.discount_in_cents[:USD]).to eq($test.user.promo.adjustment_amount * 100)
    expect(coupon.discount_percent).to be nil
  elsif $test.user.promo.adjustment_type== 'Percentage'
    expect(coupon.discount_percent).to eq($test.user.promo.adjustment_amount)
    expect(coupon.discount_in_cents).to be nil
  end
end

Then(/^the last invoice has the discount$/) do
  invoice = $test.recurly.get_last_invoice_for_account
  if $test.user.promo.adjustment_type == 'Fixed'
    expect(invoice.line_items.first.discount_in_cents).to eq($test.user.promo.adjustment_amount * 100)
  elsif $test.user.adjustment_type == 'Percentage'
    expect(invoice.line_items.first.discount_in_cents).to eq((invoice.subtotal_in_cents * $test.user.promo.adjustment_amount/100.0).ceil)
  end
end

Then(/^the recurly account should have (.*) invoices$/)do |amount|
  $test.recurly.account_has_invoices?(amount.to_i)
end

Then(/^the recurly account's last invoice should be (.*)$/) do |status|
  invoice = $test.recurly.get_last_invoice_for_account
  expect(invoice.state).to eq (status)
end

Then /the recurly rebill date should be (.*) months? (ahead|behind)$/ do |months, direction|
  if direction == 'ahead'
    original_rebill_ymd = (@original_rebill >> months.to_i).strftime('%F')
  elsif direction == 'behind'
    original_rebill_ymd = (@original_rebill << months.to_i).strftime('%F')
  end
  expect($test.recurly.get_rebill_date.strftime('%F')).to eq(original_rebill_ymd)
end
