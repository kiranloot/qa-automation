Feature: Referrer pages
@ready
Scenario: Can visit pewdiepie page
	Given an unregistered user
	When the user visits the pewdiepie page
	Then user should see pewdiepie stuff

@ready
Scenario: Can visit boogie2988 page
	Given an unregistered user
	When the user visits the boogie2988 page
	Then user should see boogie2988 stuff