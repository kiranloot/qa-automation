@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Argentina user signs up for random month subscription
        Given a registered user with a Argentina address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Argentina
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Chile user signs up for random month subscription
        Given a registered user with a Chile address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Chile
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Colombia user signs up for random month subscription
        Given a registered user with a Colombia address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Colombia
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
