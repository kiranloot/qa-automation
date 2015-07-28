@core @regression @account 
Feature: Admin Subscriptions Page
    @ready
    Scenario: Update subscription information
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And updates the subscription's information
        Then The updated information should be reflected when the user views the subscription
