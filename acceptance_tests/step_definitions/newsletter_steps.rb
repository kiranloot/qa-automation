When(/^enters a valid email$/) do
	$test.current_page.newsletter_signup($test.user.email)
end
Then(/^the user should see a confirmation modal$/) do
	expect(page).to have_content('Thank you for signing up to receive Epic Sales, Looter Intel and our ')
end
Then(/^the user should not see footer email field$/) do
  $test.email_footer_not_visible
end