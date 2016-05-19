@tracking
Feature: Displaying shipment tracking information
    @ready
    Scenario: Registered user with an active subscription is able to view their tracking information
        Given a registered user with an active subscription with tracking information
            When the user logs in
            And the user visits the my account page
        Then the user should be able to see their shipment tracking information
        And the shipment tracking information should be visible via the admin panel
