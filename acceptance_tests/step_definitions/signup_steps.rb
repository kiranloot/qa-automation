#WHENS
When /^the user joins through the modal/ do
  $test.get_valid_signup_information
  $test.modal_signup
end

When /^the user resets their password through the modal$/ do
  $test.current_page.modal_forgot_password($test.user.email)
end

#THENS
Then /^standard registration pass criteria should pass/ do
  step "the user should be logged in"
  step "the user should be on the user_accounts page"
end

Then /^signup should not succeed/ do
  expect($test.current_page.signup_failed?).to eq(true)
end

