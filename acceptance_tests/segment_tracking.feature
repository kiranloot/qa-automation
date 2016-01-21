@regression @core @segment_tracking @selenium
Feature: Segment Tracking
    @ready
    Scenario: Ensure the homepage has segment tracking
        Given an unregistered user
        When the user visits the homepage
        Then the tracking partial should exist on the page

    @krisdev
    Scenario: Ensure the signup has segment tracking
        Given an unregistered user
        When the user visits the signup page
        Then the tracking partial should exist on the page
