@core @regression @cancellation @selenium
Feature: Subscription Cancellation
    @level_up @admin @ready @recurly
    Scenario: Cancel level up sub immediately through admin
        Given a registered user with an active level up subscription
            When the admin user visits the admin page
            And logs in as an admin
            And performs an immediate cancellation on the user account
        Then the subscription should have a status of CANCELED in the admin panel
            And the user account should reflect the cancellation
            And the recurly subscription should be expired

    @pets @admin @ready @recurly @pets_inv_req
    Scenario: Cancel pets sub immediately through admin
        Given a registered user with an active pets subscription
            When the admin user visits the admin page
            And logs in as an admin
            And performs an immediate cancellation on the user account
        Then the subscription should have a status of CANCELED in the admin panel
            And the user account should reflect the cancellation
            And the recurly subscription should be expired

    @ready @gaming_inv_req
    Scenario: Subscriber cancels a gaming crate subscription
        Given   a registered user with an active gaming subscription
          When  the user logs in
          And   the user visits the my account page
          And   the user cancels their subscription
        Then    the subscription status should be set to pending cancellation
          And   the user should receive a gaming cancellation email
          And   the recurly subscription should be canceled
