@extended @world_subs
Feature: International Subscriptions
    @ready
    Scenario: Poland user signs up for random month subscription
        Given a registered user with a Poland address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Poland
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Portugal user signs up for random month subscription
        Given a registered user with a Portugal address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Portugal
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Singapore user signs up for random month subscription
        Given a registered user with a Singapore address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Singapore
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
