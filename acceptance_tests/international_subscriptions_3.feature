@regression @extended @world_subs @selenium
Feature: International Subscriptions
    #rebill date not working - Month is in Finnish
    @WIP
    Scenario: Finland user signs up for one month subscription
        Given a registered user with a Finland address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Finland
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: France user signs up for one month subscription
        Given a registered user with a France address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to France
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    #Need to fix confirmation email
    @WIP
    Scenario: Germany user signs up for one month subscription
        Given a registered user with a Germany address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Germany
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
