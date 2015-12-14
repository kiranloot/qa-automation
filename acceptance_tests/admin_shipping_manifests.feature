@selenium @regression @admin
Feature: Admin Shipping Manifests
    @ready
    Scenario: Ensure shipping manifest page loads
        Given an admin user with access to their info
        When the admin user visits the admin page
            And logs in as an admin 
            And view the shipping manifests page
        Then the shipping manifests page should load


