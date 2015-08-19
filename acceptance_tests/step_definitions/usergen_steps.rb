Given /a user via UserGen with an active subscripiton/ do
  $test.configure_user("registered", "an active subscription", true)
  step "create a random month subscription"
end