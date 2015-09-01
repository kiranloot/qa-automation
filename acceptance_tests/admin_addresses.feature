@selenium @regression
Feature: Admin adressess page
    @c
    Scenario: Admin user can search for a user address by first and last name successfully
        Given a registered user with an active subscription
            And an admin user with access to their info
        When the admin user visits the admin page
            And logs in as an admin 
            And searches for the user's address info by full name
        Then the user's address info should be correctly displayed