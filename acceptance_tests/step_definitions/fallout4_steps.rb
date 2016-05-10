#WHENS
When /^the user registers on the fallout4 page$/ do
  $test.current_page.register_for_fallout4
end

When /^the user clicks on the buy now button$/ do
  $test.current_page.click_buy_now
end

#THENS
Then /^the user should see the fallout4 subscription confirmation page$/ do
  $test.current_page.fallout4_confirmation_displayed?
end
