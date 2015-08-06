@core @regression
Feature: Subscription reactivation
    @ready
    Scenario: User reactivates cancelled subscription
        Given a registered user with a canceled subscription
            When the user logs in
            And the user visits the my account page
            And the user reactivates their subscription
        Then the reactivation should be reflected in the user account
            And the subscription should be successfully reactivated in the admin panel
            And the recurly subscription should be reactivated
