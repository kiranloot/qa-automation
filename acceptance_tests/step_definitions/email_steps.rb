#GIVENS

#WHENS
When /^The user clicks on the reset link in their email$/ do
  email = $test.mailinator.download_first_email($test.user.email)
  reset_link = email.find_link('RESET PASSWORD')[:href]
  visit(reset_link)
  $test.current_page = PasswordResetPage.new
end

#THENS
Then /the user should receive an? (.*?) email/ do |type|
  type.downcase!
  type.strip!
  $test.mailinator.verify_email(type,$test.user.email)
end
