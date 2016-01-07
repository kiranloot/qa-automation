#GIVENS

#WHENS
When /^The user clicks on the reset link in their email$/ do
  puts $test.mailinator.download_first_email($test.user.email)
end

#THENS
Then /the user should receive an? (.*?) email/ do |type|
  $test.verify_email(type)
end

