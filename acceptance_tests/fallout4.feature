@fallout4
Feature: Fallout4 Specialty Crate
    Scenario: A looter can purchase a fallout4 crate with a credit card
        Given a registered user with no prior subscription
            When the user visits the fallout4 page
            And the user registers on the fallout4 page
            And the user clicks on the buy now button
            And the user submits valid fallout4 subscription information
        Then the user should see the fallout4 subscription confirmation page
