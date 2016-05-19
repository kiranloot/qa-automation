@sellout
Feature: Pets sellouts 
    @ready @pets_inv_sellout
    Scenario: A single size sells out for pets
        Given an unregistered user
        And the pets-crate-dog-xxl-shirt variant is sold out
            When the user logs in
            And the user selects the Pets crate
            And the user selects a one month subscription plan
        Then the Dog - XXL option should be soldout

    @ready @pets_inv_sellout
    Scenario: The pets crate sells out
        Given an unregistered user
        And the Pets Crate product is sold out
            When the user logs in
            And the user selects the Pets crate
        Then the landing page should reflect the sellout

    @ready @pets_inv_sellout
    Scenario: Snacks sell out for pets and a US customer sees the sellout page
        Given an unregistered user
        And the pets-crate-food-allowed-true-food-allowed variant is sold out
            When the user logs in
            And the user selects the Pets crate
        Then the landing page should reflect the sellout

    @ready @pets_inv_sellout
    Scenario: Snacks sell out for pets and an Israel customer does not see the sellout page
        Given an unregistered user
        And the pets-crate-food-allowed-true-food-allowed variant is sold out
            When the user logs in
            And the user selects the Pets crate
            And the user sets their country to Israel
        Then the landing page should not reflect the sellout
