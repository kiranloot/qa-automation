@regression @core @segment_tracking @selenium
Feature: Segment Tracking
    @ready
    Scenario: Ensure the checkout page has segment tracking
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
        Then the tracking partial should exist on the page

    @ready
    Scenario: Ensure the checkout page has segment tracking
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the conversion tracking partial should exist on the page
