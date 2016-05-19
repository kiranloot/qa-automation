@sellout
Feature: DX sellouts 
    @ready @dx_inv_sellout
    Scenario: A single size sells out for dx
        Given an unregistered user
        And the lcdx-crate-mens-s-shirt variant is sold out
            When the user logs in
            And the user selects the DX crate
            And the user selects a one month subscription plan
        Then the Mens - S option should be soldout 

    @ready @dx_inv_sellout
    Scenario: The DX crate sells out
        Given an unregistered user
        And the Loot Crate DX product is sold out
            When the user logs in
            And the user selects the DX crate 
        Then the landing page should reflect the sellout
