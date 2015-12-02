@core @regression @levelup @selenium
Feature: Level Up
    @ready @recurly
    Scenario: A user with an active subscription can add a six month accessory subscription
        Given a registered user with an active subscription
        And The accessory level up product is available
            When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up six month subscription for the accessory crate
            And the user submits valid credit card information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a six month subscription for the accessory crate

    @ready @recurly
    Scenario: A user cancels their level up subscription
        Given a registered user with an active level up subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the subscription status should be set to pending cancellation
            And the user should receive a levelup cancellation email
            And the recurly subscription should be canceled
