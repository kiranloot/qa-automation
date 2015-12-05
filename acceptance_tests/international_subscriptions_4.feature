@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Hungary user signs up for random month subscription
        Given a registered user with a Hungary address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Hungary
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Iceland user signs up for random month subscription
        Given a registered user with a Iceland address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Iceland
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Ireland user signs up for random month subscription
        Given a registered user with a Ireland address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Ireland
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
