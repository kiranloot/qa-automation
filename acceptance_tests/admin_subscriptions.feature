@core @regression @account 
Feature: Admin Subscriptions Page
    @ready
    Scenario: View a subscription via admin panel
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And views the subscription's information
        Then the subscription information should be displayed

    @ready
    Scenario: Update subscription information
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And updates the subscription's information
        Then the updated information should be reflected when the user views the subscription

    @ready
    Scenario: Mark a subscription as having an invalid address
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And flags the subscription as having an invalid address
        Then the subscription should have a status of ACTIVE / HOLD in the admin panel
