#GIVENS
Given /^The (.*) level up product is (.*)$/ do |product,inv_status|
  inv_status.strip!
  product.strip!
  case product
  when "socks"
    variant_id = $test.db.get_variant_id("unisex-socks","Level Up Socks")
  when "accessory"
    variant_id = $test.db.get_variant_id("unisex-accessories","Level Up Accessories")
  end
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_variants
  $test.current_page = AdminVariantsPage.new
  case inv_status
  when "sold out"
    $test.current_page.set_variant_inventory(variant_id,0)
  when "available"
    $test.current_page.set_variant_inventory(variant_id,30000)
  end
  step "logs out of admin"
  #$test.set_subject_user
end

#WHENS
When /logs in as an admin/ do
  admin_user = $test.admin_user.email
  admin_password = $test.admin_user.password
  $test.current_page.admin_login(admin_user, admin_password)
  #$test.set_subject_user
end

When /the admin user visits the admin page/ do 
  step "the user visits the admin page"
end

When /logs out of admin/ do
  $test.current_page.admin_log_out
  step "the user visits the home page"
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
  #$test.set_subject_user
  $test.current_page.fill_in_subscription_name("UPDATED NAME")
  $test.current_page.select_shirt_size("Mens - S")
  $test.current_page.move_rebill_date_one_day
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
  #$test.set_subject_user
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

When /searches for the user's address info by full name/ do
  step "clicks over to addresses tab"
  $test.current_page.search_address_by_full_name($test.user.full_name)
end

When /clicks over to addresses tab/ do
  $test.current_page.click_addresses
  $test.current_page = AdminAddressPage.new
end

When /searches for the user's address info by address line 1/ do
  step "clicks over to addresses tab"
  $test.current_page.search_address_by_line_1($test.user.ship_street)
end

When /view the shipping manifests page/ do
  $test.current_page.click_shipping_manifests
  $test.current_page = AdminShippingManifestsPage.new
end

#THENS
Then /the subscription should have a status of (.*) in the admin panel/ do |status|
  $test.current_page.subscription_status_is(status)
end

Then /the subscription information should be displayed/ do
  $test.current_page.subscription_information_displayed?
end

Then /the subscription should be successfully reactivated in the admin panel/ do 
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.reactivation_successful?
  #$test.set_subject_user
end

Then /^the updated information should be reflected when the admin views the user$/ do
  $test.current_page.user_information_displayed?
end

Then (/^the subscription information change should be reflected in the admin panel$/) do
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.subscription_info_updated?
end

Then (/^the correct subscription information should be displayed in the admin panel$/) do
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.show_subscription
  $test.current_page.subscription_information_displayed?
end 

Then (/^the correct subscription billing information should be displayed in the admin panel$/) do
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.show_subscription
  $test.current_page.sub_billing_information_displayed? 
end

Then /the user's address info should be correctly displayed/ do
  $test.current_page.address_info_displayed?($test.user)
end

Then /the shipment tracking information should be visible via the admin panel/ do
  step "an admin user with access to their info"
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_subscriptions
  $test.current_page = AdminSubscriptionsPage.new
  $test.current_page.show_subscription
  $test.current_page.sub_tracking_information_displayed? 
end

Then /the shipping manifests page should load/ do
  $test.current_page.manifest_page_loaded?
end
