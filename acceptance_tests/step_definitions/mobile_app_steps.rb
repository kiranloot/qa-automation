#WHENS
When /^the user creates a new account in the mobile app$/ do
  p = $test.current_page
  p.click_create_free_account
  p.fill_in_register_email($test.user.email)
  p.click_next
  p.fill_in_first_name($test.user.first_name)
  p.fill_in_last_name($test.user.last_name)
  p.fill_in_username($test.user.email)
  p.fill_in_register_password($test.user.password)
  p.click_create_account 
  p.click_on_token_alert
end

When /^the user logs into the mobile app$/ do
  p = $test.current_page
  p.click_login
  p.fill_in_login_email($test.user.email)
  p.fill_in_login_password($test.user.password)
  p.click_sign_in
  p.click_on_token_alert
end
#THENS
Then /^the user should be on the feed screen of the mobile app$/ do 
  expect($test.current_page.is_on_the_feed_page?).to be_truthy
end

Then /^the nav bar should be visible$/ do
  expect($test.current_page.nav_bar_visible?).to be_truthy
end
