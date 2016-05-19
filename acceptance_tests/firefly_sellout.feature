@sellout
Feature: Firefly sellouts 
    @ready @firefly_inv_sellout
    Scenario: A single size sells out for firefly
        Given an unregistered user
        And the firefly-crate-unisex-s-shirt variant is sold out
            When the user logs in
            And the user selects the Firefly crate
            And the user selects a two month subscription plan
        Then the Unisex - S option should be soldout 

    @ready @firefly_inv_sellout
    Scenario: The firefly crate sells out
        Given an unregistered user
        And the Firefly Cargo Crate product is sold out
            When the user logs in
            And the user selects the Firefly crate
        Then the landing page should reflect the sellout
