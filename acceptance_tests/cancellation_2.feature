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

    @ready @recurly @pets_inv_req
    Scenario: A user cancels their pets subscription
        Given a registered user with an active pets subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the subscription status should be set to pending cancellation
            And the user should receive a pets cancellation email
            And the recurly subscription should be canceled

    @admin @ready @recurly @anime_inv_req
    Scenario: Cancel anime sub immediately through admin
        Given a registered user with an active anime subscription
            When the admin user visits the admin page
            And logs in as an admin
            And performs an immediate cancellation on the user account
        Then the subscription should have a status of CANCELED in the admin panel
            And the user account should reflect the cancellation
            And the recurly subscription should be expired

