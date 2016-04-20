@core @regression @levelup @selenium
Feature: Level Up
    @ready @recurly
    Scenario: A user with an active subscription can add an international six month accessory subscription
        Given a registered user with a Denmark address
        #And The accessory level up product is available
            When the user logs in
            And the user sets their country to Denmark
            And the user selects the Level Up crate
            And the user selects a level up six month subscription for the for her crate
            And the user submits valid subscription information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
            And recurly should have a matching international subscription

    @ready @mobile_ready
    Scenario: A user without an active subscription can add a one month shirt subscription
    Given a registered user with no prior subscription
        When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up one month subscription for the tees crate
            And the user submits valid subscription information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email

    @ready @mobile_ready
    Scenario: A user without an active subscription can add a three month bundle subscription
    Given a registered user with no prior subscription
        When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up three month subscription for the socks + wearable bundle
            And the user submits valid subscription information
        Then the new level up subscription should be added to the user account
            And the user should receive a level up email
