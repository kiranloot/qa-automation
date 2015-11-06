@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Hungary user signs up for one month subscription
        Given a registered user with a Hungary address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Hungary
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Iceland user signs up for one month subscription
        Given a registered user with a Iceland address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Iceland
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @WIP
    Scenario: Ireland user signs up for one month subscription
        Given a registered user with a Ireland address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Ireland
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
