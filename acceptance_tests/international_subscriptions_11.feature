@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: South Korea user signs up for random month subscription
        Given a registered user with a South Korea address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to South Korea
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Turkey user signs up for random month subscription
        Given a registered user with a Turkey address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Turkey
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: British user sets country at the checkout page
        Given a registered user with a United Kingdom address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a random month subscription plan
            And the user sets their country in the checkout dropdown to United Kingdom
            And the user submits valid subscription and billing information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
