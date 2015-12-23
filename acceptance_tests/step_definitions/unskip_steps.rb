When(/^the user clicks unskip$/) do
  $test.current_page.unskip_subscription
  $test.current_page.unskip_confirmation
end

Then(/^the subscription status should not be skipped$/) do
  sub_id = $test.db.get_subscriptions($test.user.email)[0]['subscription_id']
  expect($test.db.check_skipped(sub_id)).to be false
end