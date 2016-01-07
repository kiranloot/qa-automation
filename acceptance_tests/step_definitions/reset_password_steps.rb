#WHENS
When /^the user enters a new password$/ do
  $test.current_page.reset_password("newpass")
end

#THENS
Then /^the user should be able to login with their new password$/ do
  $test.log_out
  $test.log_in_or_register
  step "the user should be logged in"
end
