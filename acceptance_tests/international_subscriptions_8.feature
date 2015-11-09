@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @indev
    Scenario: South Africa user signs up for one month subscription
        Given a registered user with a SouthAfrica address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to South Africa
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @WIP
    Scenario: Spain user signs up for one month subscription
        Given a registered user with a Spain address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Spain
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @WIP
    Scenario: Sweden user signs up for one month subscription
        Given a registered user with a Sweden address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Sweden
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
