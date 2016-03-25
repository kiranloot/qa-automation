@core @regression @selenium 
Feature: Trailing slash existence in URL
	@jose
	Scenario: User enters a trailing slash in the current URL
		Given an unregistered user 
		When the user visits the home page
			And the user adds a slash at the end of the URL
		Then the page should redirect to the URL with no trailing slash