#GIVENS
Given /^that I try using factory girl/ do
  users = {1 => FactoryGirl.build(:user), 2 => FactoryGirl.build(:user), 3 => FactoryGirl.build(:user)}
  for k,v  in users do
    puts v.first_name, v.last_name, v.email
  end
end

Given /a registered user that is logged out/ do
  step "a registered user"
  step "the user logs in"
  step "the user logs out"
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

When /the user signs in to Recurly/ do
  $test.current_page.recurly_login
end

#WHENS
When /the user navigates back in the browser/ do
  page.evaluate_script('window.history.back()')
end

When /^the user visits the (.*)\s?page/ do |page|
  page.strip!
  page.downcase!
  page.gsub! /\s/, '_'
  $test.visit_page(page.to_sym)
end

When /^the user selects the (.*) crate$/ do |crate|
  $test.select_crate(crate)
end

When /we do the memory dance for (.*) minutes/ do |minutes|
  minutes.downcase!
  minutes.strip!
  dancer = Dancer.new(minutes.to_i)
end

When /the user sets their country to (.*)/ do |country|
  country.strip!
  $test.user.set_ship_to_country(country)
end

When /^the user waits for the newsletter modal to appear$/ do
  $test.current_page.wait_for_modal
end

#THENS
Then /^cool stuff should happen/ do
  $test.current_page.be_at_recurly_sandbox
  $test.current_page.on_account_tab
  $test.current_page.filter_for_user_by_email
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

Then /^the user should be on the (.*)\s?page/ do |page|
  page = page.strip
  expect($test.is_at(page.to_sym)).to eq (true)
end

Then /^the user should be logged (.*)/ do |state|
 $test.is_logged_in?
end

Then /proration should be correctly applied to the upgrade charge/ do

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

Then /the user is shown the correct (.+)/ do |type|
  # type should be 'product price', 'prorated amount', or 'payment due'
  actual = $test.current_page.get_displayed_value(type)
  expected = $test.current_page.get_expected_value(type)
  expect(actual).to include expected
end

Then /the user should not see the (.*) link/ do |link|
  $test.link_not_visible(link)
end

Then /the user should see the (.*) link/ do |link|
  $test.link_visible(link)
end
