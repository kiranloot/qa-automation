@core @regression @levelup @selenium
Feature: Level Up
    @ready
    Scenario: Level Up is not available for users without active subscriptions
        Given a registered user with no prior subscription
            When the user logs in
            Then the user should not see the Level Up link

    @ready
    Scenario: A user with an active subscription can add a one month sock subscription
        Given a registered user with an active subscription
        And The socks level up product is available
            When the user logs in
            And the user visits the level up page
            And the user selects a level up one month subscription for the socks crate
            And the user submits valid levelup information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a one month subscription for the socks crate

    @ready
    Scenario: A user with an active subscription can add a six month accessory subscription
        Given a registered user with an active subscription
        And The accessory level up product is available
            When the user logs in
            And the user visits the level up page
            And the user selects a level up six month subscription for the accessory crate
            And the user submits valid levelup information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a six month subscription for the accessory crate