@mobile_app @regression @account @selenium
Feature:Mobile App Account Registration 
    @mobile_app_ready
    Scenario: Valid signup through mobile app
        Given an unregistered user
        When the user creates a new account in the mobile app
        Then the user should be on the feed screen of the mobile app
        And the nav bar should be visible

    @mobile_app_ready_test
    Scenario: Valid login through mobile app
        Given a registered user with an active subscription
        When the user logs into the mobile app
        Then the user should be on the feed screen of the mobile app
        And the nav bar should be visible
