Feature: newsletter test
@ready
	Scenario: User signs up for newsletter on home page
	Given an unregistered user
	When the user visits the home page
	And enters a valid email
	Then the user should see a confirmation modal 
