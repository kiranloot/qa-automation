When(/^enters a valid email$/) do
	$test.current_page.newsletter_signup('lootcrate@mailinator.com')
end
Then(/^the user should see a confirmation modal$/) do
	expect(page).to have_content('Thank you for signing up to receive Epic Sales, Looter Intel and our ')
end