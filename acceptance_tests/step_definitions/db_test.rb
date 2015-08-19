Given /^an?  (.*) with an active (.*)/  do |type, with|
    with.strip!
    parsed = $test.parse_with_args(with)
    $test.configure_user(user_type.strip, with)
end

Then /the user data should match the UI/ do
  
end