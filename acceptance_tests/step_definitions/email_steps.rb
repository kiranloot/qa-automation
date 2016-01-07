#GIVENS

#WHENS
When /^The user clicks on the reset link in their email$/ do
  email = $test.mailinator.download_first_email($test.user.email)
  reset_link = /(http:\/\/mandrillapp.com\/track\/click.*)>/.match(email.body)
  visit(reset_link)
  $test.current_page = PasswordResetPage.new
end

#THENS
Then /the user should receive an? (.*?) email/ do |type|
  $test.verify_email(type)
end

