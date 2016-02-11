#GIVENS
Given(/^the subscription id is associated with one of the pin codes in the database$/) do
  #returns the pin code for verification later
  $test.user.pin_code = $test.db.associate_sub_id_with_a_pin_code
end

#WHENS
When (/^the user selects their subscription/) do
  $test.current_page.select_qualified_subscription('Loot Crate Subscription 1', 'JAN2016')
end

#THENS
Then (/^the user (should|shouldn't) see the login to redeem button$/) do |visible|
  case visible
  when "should"
    expect($test.current_page.login_to_redeem_button_visible?).to be_truthy
  when "shouldn't"
    expect($test.current_page.login_to_redeem_button_visible?).to be false
  end
end

Then (/^the user should see no active subscription message$/) do
  assert_text("No qualified active subscription found for this month")
end

Then (/^the pin code should appear on the page$/) do
  $test.current_page.code_displayed?
end
