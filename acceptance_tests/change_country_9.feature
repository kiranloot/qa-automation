@core @regression @selenium @intl_pricing
Feature: Change Country Subscribe Page Prices
    @ready
    Scenario Outline: Change from US to International Country and verify pricing.
        Given an unregistered user 
            When the user visits the signup page
            And the user submits valid signup information
            And the user visits the lootcrate_subscribe page
            And the user sets their country to <country>
        Then the <country> price for all plans should be displayed
    Examples:
      | country      |
      | South Africa |
      | South Korea  |
      | Spain        |
