@regression @core @sellout @selenium
Feature: Level Up Selluuts
#move this later
    @kristry
    Scenario: A single size sells out for level up tshirts
        Given an unregistered user
        And the level-up-tshirt-crate-mens-l-shirt variant is sold out
            When the user logs in
            And the user selects the Level Up crate
            And the user selects the Loot Tees crate for Level Up
        Then the mens l option for level up tshirt should be soldout
