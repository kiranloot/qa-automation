@core @regression @cancellation
Feature: Subscription Cancellation
    @ready
    Scenario: Subscriber cancels a subscription
        Given a registered user with an active subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the subscription status should be set to pending cancellation
            And the user should receive a subscription cancellation email
    @ready @developing
    Scenario: Cancel immediately through admin
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And performs an immediate cancellation on the user account
        Then the cancellation attempt should be successful
            And the user account should reflect the cancellation
