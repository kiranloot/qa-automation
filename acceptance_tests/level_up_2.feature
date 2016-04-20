@core @regression @levelup @selenium
Feature: Level Up
    @ready @recurly @mobile_ready
    Scenario: A user with an active subscription can add a six month accessory subscription
        Given a registered user with an active subscription
            When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up six month subscription for the for her crate
            And the user submits valid credit card information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a six month subscription for the accessory crate
            And the recurly subscription should have the correct rebill date

    @ready @mobile_ready
    Scenario: A user with an active subscription can add a three month wearable subscription
        Given a registered user with an active subscription
        When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up three month subscription for the wearables crate
            And the user submits valid credit card information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a three month subscription for the wearable crate

    @ready @mobile_ready
    Scenario: A user with an active subscription can add a six month t-shirt & accessory subscription
        Given a registered user with an active subscription
            When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up six month subscription for the for her + tee bundle
            And the user submits valid credit card information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a six month subscription for the tshirt \+ accessories crate
            And the recurly subscription should have the correct rebill date
