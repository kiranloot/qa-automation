@core @regression @account 
Feature: Admin Users Page
    @developing
    Scenario: View a user via admin panel
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And views the user's information
        Then the user's information should be displayed

    @ignore
    Scenario: Update user information
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And updates the user's information
        Then the updated information should be reflected when the admin views the user
        And the updated information should be reflected when the user views their info
