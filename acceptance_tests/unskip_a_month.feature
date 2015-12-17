@unskip
Feature: Unskip a Month
    @ready
    Scenario: unskip an already skipped account
        Given a registered user with a one month subscription
            When the user logs in
            And the user visits the my account page
            And the user skips during cancellation
            And the subscription status should be set to active with a skip
        Then the user clicks unskip
            And the subscription status should be set to active
