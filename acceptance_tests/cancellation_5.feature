@core @regression @cancellation @selenium @krisindev
Feature: Subscription Cancellation
    @dx @admin @ready @recurly @dx_inv_req
    Scenario:   Subscriber cancels a DX crate subscription
        Given   a registered user with an active dx subscription
          When  the user logs in
          And   the user visits the my account page
          And   the user cancels their subscription
        Then    the subscription status should be set to pending cancellation
          And   the user should receive a dx cancellation email
          And   the recurly subscription should be canceled

    @ready @dx_inv_req
    Scenario:   Admin immediately cancels a DX crate subscription
        Given   a registered user with an active dx subscription
          When  the admin user visits the admin page
          And   logs in as an admin
          And   performs an immediate cancellation on the user account
        Then    the subscription should have a status of CANCELED in the admin panel
          And   the user account should reflect the cancellation
          And   the recurly subscription should be expired
