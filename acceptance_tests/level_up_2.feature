@core @regression @levelup @selenium
Feature: Level Up
    @ready
    Scenario: A user without an active subscription can add a one month sock subscription
        Given a registered user with no prior subscription
        And The socks level up product is available
            When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up one month subscription for the socks crate
            And the user submits valid subscription information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a one month subscription for the socks crate

    @krisdev
    Scenario: A user with an active subscription can add a three month wearable subscription
        Given a registered user with an active subscription
        When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up three month subscription for the wearable crate
            And the user submits valid credit card information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a three month subscription for the wearable crate
