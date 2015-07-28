@core @regression @skipamonth
Feature: Skip a Month
    @off
    Scenario: Skip a one month subscription
        Given a registered user with a one month subscription
            When the user logs in
            And the user visits the my account page
            And the user skips the next month
        Then the subscription status should be set to active with a skip
            And the user should not be able to skip again
            And the user should receive a skip email

    @ready
    Scenario: Skip instead of cancel
        Given a registered user with a one month subscription
            When the user logs in
            And the user visits the my account page
            And the user skips during cancellation
        Then the subscription status should be set to active with a skip
            And the user should not be able to skip again
            And the user should receive a skip email
