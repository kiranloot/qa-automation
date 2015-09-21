@regression @core @tracking @selenium
Feature: Displaying shipment tracking information to the Looter
    @indev
    Scenario: Registered user with an active subscription is able to view their tracking information
        Given a registered user with and active subscription with tracking information
            When the user logs in
            And the user visits the my accounts page
        Then the user should be able to see their shipment tracking information

Feature: Displaying shipment tracking information to admin
    @indev
    Scenario: Admin users is able to view a subscription with tracking information
        Given a registered user with an active subscription with tracking information
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And views the subscription's information
        Then the subscription's tracking information should be displayed
