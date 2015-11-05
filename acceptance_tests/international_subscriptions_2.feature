@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Belgium user signs up for one month subscription
        Given a registered user with a Belgium address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Belgium
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
