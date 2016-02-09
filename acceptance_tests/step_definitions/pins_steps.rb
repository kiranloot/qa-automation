#WHENS

#THENS
Then(/^the user should see the login to redeem button$/) do
  expect($test.current_page.login_to_redeem_button_visible?).to be_truthy
end
