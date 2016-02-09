@regression @core @lootpins @selenium
Feature: Loot Pins
    @ready
    Scenario: A unregistered user visits the pins page
        Given an unregistered user
            When the user visits the pins page
        Then the user should see the login to redeem button

    @WIP
    Scenario: A user with no core subscription visits the pins page
        Given a registered user with no prior subscription
            When the user logs in
            And visits the pins page
        Then the user shouldn't see the login to redeem button
