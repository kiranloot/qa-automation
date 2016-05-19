@extended @world_subs
Feature: International Subscriptions
    @ready
    Scenario: Netherlands user signs up for random month subscription
        Given a registered user with a Netherlands address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Netherlands
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: New Zealand user signs up for random month subscription
        Given a registered user with a NewZealand address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to New Zealand
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Norway user signs up for random month subscription
        Given a registered user with a Norway address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Norway
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
