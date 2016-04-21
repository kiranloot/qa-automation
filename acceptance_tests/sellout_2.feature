@regression @core @sellout @selenium
Feature: Sellouts 
    @ready @pets_inv_sellout
    Scenario: Snacks sell out for pets and a US customer sees the sellout page
        Given an unregistered user
        And the pets-crate-food-allowed-true-food-allowed variant is sold out
            When the user logs in
            And the user selects the Pets crate
        Then the landing page should reflect the sellout

    @ready @pets_inv_sellout
    Scenario: Snacks sell out for pets and an Isreal customer does not see the sellout page
        Given an unregistered user
        And the pets-crate-food-allowed-true-food-allowed variant is sold out
            When the user logs in
            And the user selects the Pets crate
        Then the landing page should not reflect the sellout
