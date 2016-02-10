#WHENS

#THENS
Then (/^the user (should|shouldn't) see the login to redeem button$/) do |visible|
  case visible
  when "should"
    expect($test.current_page.login_to_redeem_button_visible?).to be_truthy
  when "shouldn't"
    expect($test.current_page.login_to_redeem_button_visible?).to be false
  end
end

Then (/^the user should see no active subscription message$/) do
  assert_text("No qualified active subscription found for this month")
end
