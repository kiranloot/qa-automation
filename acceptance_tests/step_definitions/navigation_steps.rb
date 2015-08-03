Given /^an? (.*) user$/ do |type|
  type.strip!
  $test.configure_user(type)
end

Given /^that I try using factory girl/ do
  users = {1 => FactoryGirl.build(:user), 2 => FactoryGirl.build(:user), 3 => FactoryGirl.build(:user)}
  for k,v  in users do
    puts v.first_name, v.last_name, v.email
  end
end

Given /that I want to test the db and redis objects/ do
  $test.db.registered_one_active
end

Then /the db object should be awesome/ do
  
end

Then /^cool stuff should happen/ do
  $test.current_page.be_at_recurly_sandbox
  $test.current_page.on_account_tab
  $test.current_page.filter_for_user_by_email
end

When /requests a password reset/ do
  $test.current_page.request_password_reset
end

When /attempts to reset their password using the emailed reset link/ do
  $test.visit_page(:mailinator)
  $test.current_page.reset_password_from_email
end

When /the user creates a new affiliate/ do
  $test.user.create_affiliate
end

When /logs in as an admin/ do
  $test.user.admin_login
end

When /logs out of admin/ do
  $test.current_page.admin_log_out
end

When /the user signs in to Recurly/ do
  $test.current_page.recurly_login
end

When /create a (.*) month subscription/ do |months|
  step "the user logs in"
  step "the user visits the subscribe page"
  step "the user selects a #{months} month subscription plan"
  step "the user submits valid subscription information"
  step "the user logs out"
end

When /the user selects a level up (.*) month subscription for the (.*) crate/ do |months, product|
  $test.current_page.select_level_up(product,months)
end

When /updates the subscription's information/ do
  $test.current_page.edit_subscription
  $test.set_subject_user
  $test.current_page.fill_in_subscription_name("UPDATED NAME")
  $test.current_page.select_shirt_size("M S")
  $test.current_page.move_rebill_date_one_day
  $test.current_page.click_update_subscription
end

Given /^The (.*) level up product is (.*)$/ do |product,inv_status|
  inv_status.strip!
  product.strip!
  case product
  when "socks"
    variant_id = 1
  when "accessory"
    variant_id = 2
  end
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  case inv_status
  when "sold out"
    $test.current_page.set_variant_inventory(variant_id,0,false)
  when "available"
    $test.current_page.set_variant_inventory(variant_id,100,true)
  end
  step "logs out of admin"
  $test.set_subject_user
end

Given /^an? (.*) user with (.*)/ do |user_type, with_args|
  with_args.strip!
  parsed_args = $test.parse_with_args(with_args)
  $test.configure_user(user_type.strip, with_args)
  case parsed_args
  when :registered_with_active
    step "create a random month subscription"
  when :one_month
    step "create a one month subscription"
  when :canceled
    step "create a one month subscription"
    step "an admin user with access to their info"
    step "the user visits the admin page"
    step "logs in as an admin"
    step "performs an immediate cancellation on the user account"
    step "logs out of admin"
    $test.set_subject_user
  when :multi_use_promo
    step "an admin user with access to their info"
    step "the user visits the admin page"
    step "logs in as an admin"
    promo_code = $test.current_page.create_promotion
    step "logs out of admin"
    $test.set_subject_user
    $test.user.coupon_code = promo_code
  end
end

Given /a registered user that is logged out/ do
  step "a registered user"
  step "the user logs in"
  step "the user logs out"
end

When /the user reactivates their subscription/ do
  $test.current_page.reactivate_subscription
end

When /the user upgrades to a (.*) month subscription/ do |months|
  $test.user.upgrade_plan(months)
end

When /^the user visits the (.*)\s?page/ do |page|
  page.strip!
  page.downcase!
  page.gsub! /\s/, '_'
  $test.visit_page(page.to_sym)
end

When /the admin user visits the admin page/ do 
  step "the user visits the admin page"
end

When /the user logs (.*)$/ do |in_out|
  in_out = in_out.strip.downcase
  if in_out == "in"
    $test.log_in_or_register
  else
    $test.log_out
  end
end

Given /that I want a quick test of my setup/ do
  page.find("#wf-newsletter-modal > button").click
  click_link("Log In")
  sleep 0.5
  fill_in("user_email", :with => "lootcratetest001@mailinator.com")
  fill_in("user_password", :with => "password")
  click_button("Log In")
  sleep 0.5
end

Then /here it is/ do
  if page.has_css?("body > div.alert-bg > div > div > div > a")
    page.find("body > div.alert-bg > div > div > div > a").click
  end
  assert_text("My Account")
  click_link("My Account")
  click_link("Log Out")
  sleep 1
end

When /performs an immediate cancellation on the user account/ do
  $test.current_page.admin_cancel_immediately
end

Then /the user should receive an? (.*?) email/ do |type|
  $test.verify_email(type)
end

And /^the user submits (.*?) information/ do |arg_string|
  args = arg_string.split(" ")
  adjective = args.shift
  type = args.reject(&:empty?).join(' ')
  $test.submit_information(adjective, type)
end

When /^the user selects a (.*) month subscription plan/ do |months|
  $test.current_page.select_plan(months)
end 

Then /^the user should be on the (.*)\s?page/ do |page|
  page = page.strip
  expect($test.is_at(page.to_sym)).to eq (true)
end 

Then /the new subscription should be added to the user account/ do 
  step "the user visits the my account page"
  $test.current_page.verify_subscription_added
end

Then /the new level up subscription should be added to the user account/ do
  step "the user visits the my account page"
  $test.current_page.verify_levelup_subscription_added
end

Then /^the user should be logged (.*)/ do |state|
 $test.is_logged_in?
end

Then /standard new subscription pass criteria should pass/ do
  step "the new subscription should be added to the user account"
end

Then /subscription creation should fail due to (.*?)$/ do |fault|
  fault.strip!
  fault.downcase!
  $test.current_page.subscription_failed?(fault)
end

When /^the user joins through the modal/ do
  $test.get_valid_signup_information
  $test.modal_signup
end

Then /^standard registration pass criteria should pass/ do
  step "the user should be logged in"
  step "the user should be on the user_accounts page"
end

Then /^signup should not succeed/ do
  expect($test.current_page.signup_failed?).to eq(true)
end

Then /sales tax should be applied to the transaction price/ do
  $test.user.tax_applied?
end

When /we do the memory dance for (.*) minutes/ do |minutes|
  minutes.downcase!
  minutes.strip!
  dancer = Dancer.new(minutes.to_i)
end

When /the user cancels their subscription/ do
  step "the user visits the my account page"
  $test.current_page.cancel_subscription
end

When /the user skips the next month/ do
  step "the user visits the my account page"
  $test.current_page.skip_a_month
end

When /the user skips during cancellation/ do
  step "the user visits the my account page"
  $test.current_page.skip_during_cancel
end

Then /the subscription status should be set to pending cancellation/ do
  $test.current_page.cancellation_pending?
end

Then /the subscription status should be set to active with a skip/ do
  $test.current_page.month_skipped?
end

Then /the user should not be able to skip again/ do
  $test.current_page.cannot_skip_again?
end

Then /proration should be correctly applied to the upgrade charge/ do

end

When /the user sets their country to (.*)/ do |country|
  country.strip!
  country.downcase!
  $test.user.set_country(country)
end

Then /the (.*) price for all plans should be displayed/ do |domain|
  $test.current_page.verify_plan_prices(domain)
end

Then /the affiliate should be created successfully/ do
  $test.affiliate_created?
end

Then /the affiliate redirect should function correctly/ do 
  $test.affiliate_working?
end

Then /the promo discount should be applied to the transaction/ do 
  $test.user.discount_applied?
end

Then /the cancellation attempt should be successful/ do
  $test.current_page.cancellation_successful?
end

Then /the user account should reflect the cancellation/ do
  $test.set_subject_user
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.subscription_cancelled?
end

Then /the reactivation should be reflected in the user account/ do
  $test.current_page.subscription_reactivated?
end

Then /the subscription should be successfully reactivated in the admin panel/ do 
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.reactivation_successful?
end

Then /the user is shown the correct (.+)/ do |type|
  # type should be 'product price', 'prorated amount', or 'payment due'
  actual = $test.current_page.get_displayed_value(type)
  expected = $test.current_page.get_expected_value(type)
  expect(actual).to include expected
end

Then /the user should not see the (.*) link/ do |link|
  $test.link_not_visible(link)
end

Then /the updated information should be reflected when the user views the subscription/ do
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.subscription_updated?
end
