@regression @core @sellout @selenium
Feature: Gaming sellouts 
    @ready @gaming_inv_sellout
    Scenario: A single size sells out for gaming
        Given an unregistered user
        And the gaming-crate-mens-s-shirt variant is sold out
            When the user logs in
            And the user selects the Gaming crate
            And the user selects a one month subscription plan
        Then the Mens - S option should be soldout 

    @ready @gaming_inv_sellout
    Scenario: The gaming crate sells out
        Given an unregistered user
        And the Gaming Crate product is sold out
            When the user logs in
            And the user selects the Gaming crate
        Then the landing page should reflect the sellout

    @ready @gaming_inv_sellout
    Scenario: User goes to one page checkout for a sold out crate
        Given an unregistered user
        And   the Gaming Crate product is sold out
            When the user visits the gaming_opc page
        Then the opc page should reflect the sellout
