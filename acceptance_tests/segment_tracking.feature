@regression @core @segment_tracking @selenium
Feature: Segment Tracking
    @ready
    Scenario: Ensure the home page has segment tracking
        Given an unregistered user
        When the user visits the homepage
        Then the tracking partial should exist on the page

    @ready
    Scenario: Ensure the signup page has segment tracking
        Given an unregistered user
        When the user visits the signup page
        Then the tracking partial should exist on the page

    @ready
    Scenario: Ensure the lootcrate landing has segment tracking
        Given an unregistered user
        When the user visits the lootcrate_landing page
        Then the tracking partial should exist on the page

    @ready
    Scenario: Ensure the anime landing has segment tracking
        Given an unregistered user
        When the user visits the anime_landing page
        Then the tracking partial should exist on the page

    @ready
    Scenario: Ensure the pets landing has segment tracking
        Given an unregistered user
        When the user visits the pets_landing page
        Then the tracking partial should exist on the page
