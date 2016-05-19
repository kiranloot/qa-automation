@account @admin
Feature: Admin Inventory Units Page
    @ready @anime_inv_req
    Scenario: Check Inventory Count
    When      the user queries inventory for Anime Crate item named Womens - L
    And       the admin user visits the admin page
    And       logs in as an admin
    And       clicks over to inventory units tab
    Then      the inventory value should match the queried value

    @readya @anime_inv_req
    Scenario: Check Variant Inventory Count
    When      the user queries inventory for Anime Crate item named Womens - L
    And       the admin user visits the admin page
    And       logs in as an admin
    And       clicks over to variants tab
    Then      the inventory value should match the queried value
