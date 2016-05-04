@core @regression @account @selenium
Feature: User Detail Editing
    @tofix
    Scenario: The user edits their dx subscriptions subscription info
        Given a registered user with an active dx subscription
            When the user logs in
            And the user edits their subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel
