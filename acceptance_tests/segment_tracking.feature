@regression @core @segment_tracking @selenium
Feature: Segment Tracking
    @krisdev
    Scenario: Ensure the Homepage has segment tracking
        Given an unregistered user
        When the user visits the homepage
        Then the tracking partial should exist on the page
