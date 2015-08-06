When /the user selects a level up (.*) month subscription for the (.*) crate/ do |months, product|
  $test.current_page.select_level_up(product,months)
end

Then /the new level up subscription should be added to the user account/ do
  step "the user visits the my account page"
  $test.current_page.verify_levelup_subscription_added
end

