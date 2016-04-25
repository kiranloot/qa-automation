@core @regression @cancellation @selenium
Feature: Subscription Cancellation
    @level_up @admin @ready @recurly
    Scenario:   Subscriber cancels a firefly crate subscription
        Given   a registered user with an active firefly subscription
          When  the user logs in
          And   the user visits the my account page
          And   the user cancels their subscription
        Then    the subscription status should be set to pending cancellation
          And   the user should receive a firefly cancellation email
          And   the recurly subscription should be canceled

    @ready
    Scenario:   Subscriber immediately cancels a gaming crate subscription
        Given   a registered user with an active gaming subscription
          When  the admin user visits the admin page
          And   logs in as an admin
          And   performs an immediate cancellation on the user account
        Then    the subscription should have a status of CANCELED in the admin panel
          And   the user account should reflect the cancellation
          And   the recurly subscription should be expired

    @ready
    Scenario:   Subscriber immediately cancels a firefly crate subscription
        Given   a registered user with an active firefly subscription
          When  the admin user visits the admin page
          And   logs in as an admin
          And   performs an immediate cancellation on the user account
        Then    the subscription should have a status of CANCELED in the admin panel
          And   the user account should reflect the cancellation
          And   the recurly subscription should be expired
