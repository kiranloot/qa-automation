#GIVENS
Given /^an? (.*) user$/ do |type|
  type.strip!
  $test.configure_user(type)
end

Given /^an? (.*) user with (.*)/ do |user_type, with_args|
  with_args.strip!
  $test.configure_user(user_type.strip, with_args)
  parsed_args = $test.user.trait
  if $test.user.need_sub?
    sl = StepList.new(parsed_args)
    sl.each do |s|
      step s
    end
  end
end

Given /^a different billing address$/ do
  $test.configure_billing_address
end

Given /^has a (.*) promo code for (\d*) (\w*)/ do |promo_type, adjustment_amount, adjustment_type|
  $test.user.create_user_promotion(promo_type, adjustment_type, adjustment_amount)
  StepList.new('promo').each do |s|
    step s
  end
end

#WHENS
When /create a\s(.*)\smonth subscription/ do |months|
  step "the user logs in"
  step "the user selects the Loot Crate crate"
  step "the user selects a #{months} month subscription plan"
  step "the user submits valid subscription information"
  step "the user logs out"
end

When /move subscription to last month/ do
  #spin for 5 seconds until you get results
  sub_id = nil
  5.times do
    results = $test.db.get_subscriptions($test.user.email)
    if results.any?
      sub_id = results[0]['subscription_id']
      break
    else
      sleep(1)
    end
  end
  $test.db.move_sub_to_prev_month(sub_id)
end

When /create a (\w*) month (.*) subscription/ do |months,crate|
  step "the user logs in"
  step "the user selects the #{crate} crate"
  step "the user selects a #{months} month subscription plan"
  step "the user submits valid subscription information"
  step "the user logs out"
end

When /create an international (\w*) month (.*) subscription with a (.*) address/ do |months,crate,country|
  step "a registered user with a #{country} address"
  step "the user logs in"
  step "the user selects the #{crate} crate"
  step "the user sets their country to #{country}"
  step "the user selects a #{months} month subscription plan"
  step "the user submits valid subscription information"
  step "the user logs out"
end

When /create a level up (\w*) month (.*) subscription/ do |months, product|
  step "the user logs in"
  step "the user selects the Level Up crate"
  step "the user selects a level up #{months} month subscription for the #{product} crate"
  step "the user submits valid subscription information"
  step "the user logs out"
end

When /the user upgrades to a (.*) month subscription/ do |months|
  $test.user.upgrade_plan(months)
end

When /^the user chooses a (.*) month subscription upgrade$/ do |months|
    $test.current_page.select_upsell_plan(months)
end

When /the user reactivates their subscription/ do
  $test.current_page.reactivate_subscription
end

When /the user logs (in|out)$/ do |in_out|
  case in_out
  when "in"
    step "the user visits the signup page"
    $test.current_page.log_in_or_register
  when "out"
    $test.current_page.log_out
  end
end

When /^the user selects a (.*) month subscription plan/ do |months|
  $test.current_page.select_plan(months)
end

When /^the user submits (.*?) information/ do |arg_string|
  addbilling = false
  if arg_string.include?(" and billing")
    addbilling = true
    arg_string.slice!(" and billing")
  end
  args = arg_string.split(" ")
  adjective = args.shift
  type = args.reject(&:empty?).join(' ')
  $test.submit_information(adjective, type, addbilling)
end

When /^the user edits their (.*)$/ do |info|
  sub_id = $test.db.get_subscriptions($test.user.email)[0]['subscription_id']
  step "the user visits the my account page"
  if ENV['DRIVER'] == 'appium'
    $test.current_page = MyAccountMobilePage.new
  end
  case info
  when 'subscription info'
    $test.current_page.edit_subscription_info(sub_id)
    $test.current_page.fill_in_subscription_name(sub_id, "NEW SUB NAME")
    $test.current_page.select_shirt_size(sub_id, "Womens - S")
    $test.current_page.click_update
  when 'shipping address'
    $test.current_page.edit_shipping_address(sub_id)
    $test.current_page.fill_in_shipping_first_name(sub_id, Faker::Name.first_name)
    $test.current_page.fill_in_shipping_last_name(sub_id, Faker::Name.last_name)
    $test.current_page.fill_in_shipping_address_1(sub_id, Faker::Address.street_address)
    $test.current_page.fill_in_shipping_city(sub_id, Faker::Address.city)
    $test.current_page.fill_in_shipping_zip(sub_id, Faker::Address.zip_code)
    $test.current_page.select_shipping_state(sub_id, Faker::Address.state_abbr)
    $test.current_page.click_update
  when 'billing information'
    $test.current_page.edit_billing_info(sub_id)
    $test.current_page.fill_in_cc_name(sub_id, Faker::Name.name)
    $test.current_page.fill_in_cc_number($test.user.cc)
    $test.current_page.fill_in_cvv_number($test.user.cvv)
    $test.current_page.fill_in_billing_address_1(sub_id, Faker::Address.street_address)
    $test.current_page.fill_in_billing_city(sub_id, Faker::Address.city)
    $test.current_page.select_billing_state(sub_id, Faker::Address.state_abbr)
    $test.current_page.fill_in_billing_zip(sub_id, Faker::Address.zip_code)
    $test.current_page.click_update
  end
end

#THENS
Then /the new subscription should be added to the user account/ do
  step "the user visits the my account page"
  $test.current_page.verify_subscription_added
end

Then /the user should still have their subscription/ do
  step "the user visits the my account page"
  $test.current_page.verify_subscription_added
end

Then /standard new subscription pass criteria should pass/ do
  step "the new subscription should be added to the user account"
end

Then /subscription creation should fail due to (.*?)$/ do |fault|
  fault.strip!
  fault.downcase!
  $test.current_page.subscription_failed?(fault)
end

Then /sales tax should be applied to the transaction price/ do
  $test.user.tax_applied?
end

Then /the subscription status should be set to pending cancellation/ do
  $test.current_page.cancellation_pending?
end

Then /the subscription status should be set to active with a skip/ do
  $test.current_page.month_skipped?
end

Then /the subscription status should be set to on hold/ do
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.sub_on_hold?
end

Then /the promo discount should be applied to the transaction/ do
  $test.current_page.discount_applied?
end

Then /the user's information should be displayed/ do
  $test.current_page.user_information_displayed?
end

Then /the user account should reflect the cancellation/ do
  ##$test.set_subject_user
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.subscription_cancelled?
end

Then /the reactivation should be reflected in the user account/ do
  $test.current_page.subscription_reactivated?
end

Then /the updated information should be reflected when the user views the subscription/ do
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.subscription_updated?
end

Then /^the updated shipping information should be reflected when the user views the subscription$/ do
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.shipping_info_updated?
end

Then (/^the billing address change should be reflected in the user account$/) do
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.billing_info_updated?
end

Then /the updated information should be reflected when the user views their info/ do
  step "logs out of admin"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.verify_user_information
end

Then /^the user should be able to see their shipment tracking information$/ do
  $test.current_page.tracking_info_displayed?
end

Then /^the user is displayed the correct tax$/ do
  $test.current_page.tax_displayed?
end

Then /^the subscriptions rebill date should be adjusted by (.*) month$/ do |months|
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  #This code converts the ruby time object into date time
  #That enables us to use the ">>" operator to move the rebill date ahead n number of months
  $test.user.recurly_rebill_date = ($test.user.recurly_rebill_date.to_datetime >> months.to_i).new_offset(-8.0/24)
  puts $test.user.recurly_rebill_date
  $test.user.new_rebill_date = $test.convert_time_to_display_rebill($test.user.recurly_rebill_date)
  puts $test.user.new_rebill_date
  $test.current_page.rebill_date_updated?
end

#To Do consolidate all status checks into one keyword/function
Then /^the subscription's status should be (.*)$/ do |status|
  assert_text(status)
end

Then /^the (.*) option should be soldout/ do |variant|
  $test.current_page.shirt_variant_soldout?(variant)
end

Then /^the landing page should reflect the sellout$/ do
  assert_text("SOLD OUT!")
end

Then /^the user should not see the credit card information fields$/ do
  $test.current_page.credit_card_fields_gone?
end
