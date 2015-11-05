@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Denmark user signs up for one month subscription
        Given a registered user with a Denmark address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Denmark
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Australian user signs up for one month subscription
        Given a registered user with a Australia address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Australia
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Austria user signs up for one month subscription
        Given a registered user with a Austria address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Austria
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
