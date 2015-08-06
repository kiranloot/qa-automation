#GIVENS

#WHENS
When /attempts to reset their password using the emailed reset link/ do
  $test.visit_page(:mailinator)
  $test.current_page.reset_password_from_email
end

#THENS
Then /the user should receive an? (.*?) email/ do |type|
  $test.verify_email(type)
end

