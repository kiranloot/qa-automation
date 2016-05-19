@skipamonth
Feature: Skip a Month
    @ready
    Scenario: Skip core crate
        Given a registered user with a one month subscription
            When the user logs in
            And the user notes the recurly rebill date
            And the user visits the my account page
            And the user skips during cancellation
        Then the subscription status should be set to active with a skip
            And the user should not be able to skip again
            And the user should receive a skip email
            And the recurly rebill date should be 1 month ahead

    @ready
    Scenario: Prevent skipping again if user navigates back with browser
        Given a registered user with a one month subscription
            When the user logs in
            And the user visits the my account page
            And the user skips during cancellation
            And the user navigates back in the browser
            And the user attempts to skip again
        Then the user should see the cancellation page

    @ready 
    Scenario: Skip level up crate
        Given a registered user with an active level up subscription
            When the user logs in
            And the user notes the recurly rebill date
            And the user visits the my account page
            And the user skips during cancellation
        Then the subscription status should be set to active with a skip
            And the user should not be able to skip again
            And the user should receive a skip email
            And the recurly rebill date should be 1 month ahead
