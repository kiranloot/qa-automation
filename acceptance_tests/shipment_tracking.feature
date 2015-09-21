@regression @core @tracking @selenium
Feature: Displaying shipment tracking information to the Looter
    @indev
    Scenario: Registered user with an active subscription is able to view their tracking information
        Given a registered user with and active subscription with tracking information
            When the user logs in
            And the user visits the my accounts page
        Then the user should be able to see their shipment tracking information
        And the shipment tracking information should be visible via the admin panel
