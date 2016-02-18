@core @regression @account @selenium @admin
Feature: Admin Inventory Units Page

    Scenario: Check Inventory Count
    Given     an admin user with access to their info
    When      the user queries inventory for Level Up Bundle item named Womens - L
    And       the admin user visits the admin page
    And       logs in as an admin
    And       clicks over to inventory units tab
    Then      the inventory value should match the queried value


    Scenario: Check Variant Inventory Count
    Given     an admin user with access to their info
    When      the user queries inventory for Level Up Bundle item named Womens - L
    And       the admin user visits the admin page
    And       logs in as an admin
    And       clicks over to variants tab
    Then      the inventory value should match the queried value
