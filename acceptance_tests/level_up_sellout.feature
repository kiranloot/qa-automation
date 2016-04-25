@regression @core @sellout @selenium
Feature: Level Up Selluuts
#move this later
    @ignore
    Scenario: A single size sells out for level up
        Given an unregistered user
        And the level-up-tshirt-crate-mens-l-shirt variant is sold out
            When the user logs in
            And the user selects the Level Up crate
        Then the Mens - L option for level up tshirt should be soldout
