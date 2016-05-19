@admin
Feature: Admin adressess page
    @ready
    Scenario: Admin user can search for a user address by first and last name successfully
        Given a registered user with an active subscription
        When the admin user visits the admin page
            And logs in as an admin 
            And searches for the user's address info by full name
        Then the user's address info should be correctly displayed

    @ready
    Scenario: Admin user can search for a user address by address line 1 successfully
        Given a registered user with an active subscription
        When the admin user visits the admin page
            And logs in as an admin
            And searches for the user's address info by address line 1
        Then the user's address info should be correctly displayed
