@core @regression @account @selenium
Feature: User Detail Editing
    @ready
    Scenario: The user edits their firefly subscriptions subscription info
        Given a registered user with an active firefly subscription
            When the user logs in
            And the user edits their firefly subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel

    @ready
    Scenario: The user edits their pets subscriptions subscription info
        Given a registered user with an active pets subscription
            When the user logs in
            And the user edits their pet subscription info
        Then the updated pets information should be reflected when the user views the subscription
            And the pet subscription information change should be reflected in the admin panel

    @ready
    Scenario: The user edits their dx subscriptions subscription info
        Given a registered user with an active dx subscription
            When the user logs in
            And the user edits their subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel
