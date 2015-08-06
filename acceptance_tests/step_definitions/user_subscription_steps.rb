#GIVENS
Given /^an? (.*) user$/ do |type|
  type.strip!
  $test.configure_user(type)
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
    $test.current_page.click_promotions
    $test.current_page = AdminPromotionsPage.new
    promo_code = $test.current_page.create_promotion
    step "logs out of admin"
    $test.set_subject_user
    $test.user.coupon_code = promo_code
  end
end

#WHENS
When /create a (.*) month subscription/ do |months|
  step "the user logs in"
  step "the user visits the subscribe page"
  step "the user selects a #{months} month subscription plan"
  step "the user submits valid subscription information"
  step "the user logs out"
end

When /the user upgrades to a (.*) month subscription/ do |months|
  $test.user.upgrade_plan(months)
end

When /the user reactivates their subscription/ do
  $test.current_page.reactivate_subscription
end

When /the user logs (.*)$/ do |in_out|
  in_out = in_out.strip.downcase
  if in_out == "in"
    $test.log_in_or_register
  else
    $test.log_out
  end
end

When /^the user selects a (.*) month subscription plan/ do |months|
  $test.current_page.select_plan(months)
end 

When /^the user submits (.*?) information/ do |arg_string|
  args = arg_string.split(" ")
  adjective = args.shift
  type = args.reject(&:empty?).join(' ')
  $test.submit_information(adjective, type)
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

Then /the promo discount should be applied to the transaction/ do 
  $test.user.discount_applied?
end

Then /the subscription information should be displayed/ do
  $test.current_page.subscription_information_displayed?
end

Then /the user's information should be displayed/ do
  $test.current_page.user_information_displayed?
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

Then /the updated information should be reflected when the user views the subscription/ do
  step "the user visits the home page"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.subscription_updated?
end

Then /the updated information should be reflected when the user views their info/ do
  step "logs out of admin"
  step "the user logs in"
  step "the user visits the my account page"
  $test.current_page.verify_user_information
end

