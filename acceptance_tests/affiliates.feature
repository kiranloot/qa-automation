@extended @affiliates
Feature: Affiliates
    @ready
    Scenario: Create new affiliate and verify redirect
        Given an admin user
            When the user visits the admin page
            And logs in as an admin
            And the user creates a new affiliate
        Then the affiliate should be created successfully
            And the affiliate redirect should function correctly
