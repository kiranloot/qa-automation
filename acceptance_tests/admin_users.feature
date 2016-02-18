@core @regression @account @selenium @admin
Feature: Admin Users Page
    @ready
    Scenario: View a user via admin panel
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And views the user's information
        Then the user's information should be displayed

    @ready
    Scenario: Update user information
        Given a registered user with an active subscription
            And an admin user with access to their info
            When the admin user visits the admin page
            And logs in as an admin
            And updates the user's information
        Then the updated information should be reflected when the admin views the user
        And the updated information should be reflected when the user views their info
#        commenting out, need to resolve QAUTO-86 to get this to work 100% of the time 
#        And the user should still have their subscription
