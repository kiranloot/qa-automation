@sailthru
Feature: Sailthru Integration
    @ready
    Scenario: User signs up for newsletter on home page
  	Given an unregistered user
    And   the user's email does not exist in sailthru
	  When  the user visits the home page
  	And   enters a valid email
  	Then  the user should see a confirmation modal 
    And   the user's email should be in the Loot Crate Master List bucket in sailthru
