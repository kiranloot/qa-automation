@core @regression @cancellation @selenium
Feature: Subscription Cancellation
    @ready @gp @recurly
    Scenario: Subscriber cancels a subscription
        Given a registered user with an active subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the subscription status should be set to pending cancellation
            And the user should receive a subscription cancellation email
            And the recurly subscription should be canceled

    @ready @recurly
    Scenario: Cancel immediately through admin
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And performs an immediate cancellation on the user account
        Then the subscription should have a status of CANCELED in the admin panel
            And the user account should reflect the cancellation
            And the recurly subscription should be expired

    @indev
    Scenario: Subscriber cancels an anime crate subscription
        Given a registered user with an active anime subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the subscription status should be set to pending cancellation
            And the user should receive an anime cancellation email
            And the recurly subscription should be canceled
