#WHENS
When(/^the user attempts to skip again/) do
  $test.current_page = SkipPage.new
  $test.current_page.click_skip
end

When /the user skips the next month/ do
  step "the user visits the my account page"
  $test.current_page.skip_a_month
end

When /the user skips during cancellation/ do
  step "the user visits the my account page"
  $test.current_page.skip_during_cancel
end

When /the user cancels their subscription/ do
  step "the user visits the my account page"
  $test.current_page.cancel_subscription
end

#THENS
Then /the user should not be able to skip again/ do
  $test.current_page.cannot_skip_again?
end

Then /the user should see the cancellation page/ do
  assert_text("WE'RE SORRY YOU NEED TO GO")
end
