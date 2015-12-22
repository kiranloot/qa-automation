@core @regression @levelup @selenium
Feature: Level Up
    @ready @recurly
    Scenario: A user with an active subscription can add an international six month accessory subscription
        Given a registered user with a Denmark address
        #And The accessory level up product is available
            When the user logs in
            And the user sets their country to Denmark
            And the user selects the Level Up crate
            And the user selects a level up six month subscription for the accessory crate
            And the user submits valid subscription information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a matching international subscription
