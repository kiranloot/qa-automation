#GIVENS
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
  $test.current_page.click_variants
  $test.current_page = AdminVariantsPage.new
  case inv_status
  when "sold out"
    $test.current_page.set_variant_inventory(variant_id,0,false)
  when "available"
    $test.current_page.set_variant_inventory(variant_id,100,true)
  end
  step "logs out of admin"
  $test.set_subject_user
end

#WHENS
When /logs in as an admin/ do
  admin_user = $test.user.email
  admin_password = $test.user.password
  $test.current_page.admin_login(admin_user, admin_password)
end

When /the admin user visits the admin page/ do 
  step "the user visits the admin page"
end

When /logs out of admin/ do
  $test.current_page.admin_log_out
end

When /the user creates a new affiliate/ do
  $test.current_page.click_affiliates
  $test.current_page = AdminAffiliatesPage.new
  $test.current_page.create_affiliate
end

When /views the subscription's information/ do
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.show_subscription
end

When /updates the subscription's information/ do
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.edit_subscription
  $test.set_subject_user
  $test.current_page.fill_in_subscription_name("UPDATED NAME")
  $test.current_page.select_shirt_size("M S")
  #$test.current_page.move_rebill_date_one_day
  $test.current_page.click_update_subscription
end

When /flags the subscription as having an invalid address/ do
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.flag_subscription_as_invalid
end

When /views the user's information/ do
  $test.current_page.click_users
  $test.current_page = AdminUsersPage.new
  $test.current_page.view_user
end

When /updates the user's information/ do
  $test.current_page.click_users
  $test.current_page = AdminUsersPage.new
  $test.current_page.edit_user
  $test.set_subject_user
  $test.current_page.fill_in_email
  $test.current_page.fill_in_password
  $test.current_page.fill_in_full_name
  $test.current_page.click_update_user
end

When /performs an immediate cancellation on the user account/ do
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.admin_cancel_immediately
end


#THENS
Then /the subscription should have a status of (.*) in the admin panel/ do |status|
  $test.current_page.subscription_status_is(status)
end

Then /the subscription should be successfully reactivated in the admin panel/ do 
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.reactivation_successful?
  $test.set_subject_user
end

Then /^the updated information should be reflected when the admin views the user$/ do
  $test.current_page.user_information_displayed?
end

Then(/^the subscription information change should be reflected in the admin panel$/) do
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.subscription_info_updated?
end
