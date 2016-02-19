@core @regression @selenium
Feature: Change Country Subscribe Page Prices
    @ready
    Scenario: Change from US to Denmark and verify pricing.
        Given an unregistered user 
            When the user visits the signup page
            And the user submits valid signup information
            And the user visits the lootcrate_subscribe page
            And the user sets their country to Denmark
        Then the Denmark price for all plans should be displayed

