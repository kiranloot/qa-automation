@regression @core @lootpins @selenium
Feature: Loot Pins
    @ready
    Scenario: A unregistered user visits the pins page
        Given an unregistered user
            When the user visits the pins page
        Then the user should see the login to redeem button

    @KrisWIP
    Scenario: A user with no core subscription visits the pins page
        Given a registered user with no prior subscription
        And the system has Core Crate pin codes for the current month
            When the user logs in
            And the user visits the pins page
        Then the user shouldn't see the login to redeem button
        And the user should see no active subscription message
