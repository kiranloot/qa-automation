@extended @world_subs
Feature: International Subscriptions
    @ready
    Scenario: South Africa user signs up for random month subscription
        Given a registered user with a SouthAfrica address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to South Africa
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Spain user signs up for random month subscription
        Given a registered user with a Spain address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Spain
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Sweden user signs up for random month subscription
        Given a registered user with a Sweden address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Sweden
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
