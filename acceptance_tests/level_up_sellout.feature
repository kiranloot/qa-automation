@regression @core @sellout @selenium
Feature: Level Up Sellouts
    @ready @lutshirt_inv_sellout
    Scenario: A single size sells out for level up tshirts
        Given an unregistered user
        And the level-up-tshirt-crate-mens-l-shirt variant is sold out
            When the user logs in
            And the user selects the Level Up crate
            And selects the tees level up crate 
        Then the mens l option for level up tshirt should be soldout
