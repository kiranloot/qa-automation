@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Denmark user signs up for random month subscription
        Given a registered user with a Denmark address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Denmark
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
        And the recurly subscription data is fully validated

    @ready
    Scenario: Australian user signs up for random month subscription
        Given a registered user with a Australia address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Australia
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Austria user signs up for random month subscription
        Given a registered user with a Austria address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Austria
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
