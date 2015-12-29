@core @regression @cancellation @selenium
Feature: Subscription Cancellation
    @ready @recurly
    Scenario: A user cancels their level up subscription
        Given a registered user with an active level up subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the subscription status should be set to pending cancellation
            And the user should receive a levelup cancellation email
            And the recurly subscription should be canceled
