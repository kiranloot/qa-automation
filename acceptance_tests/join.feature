@ready
Feature: Test 
Scenario: Valid signup through the Loot Crate join modal 
	Given an unregistered user
	And the user selects the Loot Crate crate 
	And the user joins through the modal
	Then the user should be logged in

@ready
Scenario: Valid signup through the Anime join modal 
	Given an unregistered user
	And the user selects the Anime crate 
	And the user joins through the modal
	Then the user should be logged in

@ready
Scenario: Valid signup through the Level Up join modal 
	Given an unregistered user
	And the user selects the Level Up crate 
	And the user joins through the modal
	Then the user should be logged in