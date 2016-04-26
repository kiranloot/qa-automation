@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Japan user signs up for random month subscription
        Given a registered user with a Japan address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Japan
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email


    Scenario: Brazil user signs up for random month subscription
        Given a registered user with a Brazil address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Brazil
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
