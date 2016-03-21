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

    @pets @admin @ready @recurly
    Scenario: Cancel pets sub immediately through admin
        Given a registered user with an active pets subscription
            When the admin user visits the admin page
            And logs in as an admin
            And performs an immediate cancellation on the user account
        Then the subscription should have a status of CANCELED in the admin panel
            And the user account should reflect the cancellation
            And the recurly subscription should be expired

