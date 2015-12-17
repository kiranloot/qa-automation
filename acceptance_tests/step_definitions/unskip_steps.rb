When(/^the user clicks unskip$/) do
  $test.current_page.unskip_subscription
end

Then(/^the subscription status should be set to active$/) do
  $test.current_page.month_active?
end