@extended @world_subs
Feature: International Subscriptions
    @ready
    Scenario: Switzerland user signs up for random month subscription
        Given a registered user with a Switzerland address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Switzerland
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: United Kingdom user signs up for random month subscription
        Given a registered user with a UnitedKingdom address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to United Kingdom
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready @no_cc
    Scenario: Mexico user signs up for random month subscription
        Given a registered user with a Mexico address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Mexico
            And the user selects a random month subscription plan
        Then the user should not see the credit card information fields
#            And the user submits valid subscription information
#        Then the new subscription should be added to the user account
#        And recurly should have a matching international subscription
#        And the recurly billing address should have no state
#        And the user should receive a subscription confirmation email
