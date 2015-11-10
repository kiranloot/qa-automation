@regression @core @sailthru @selenium
Feature: Sailthru Integration
    @ready
    Scenario: Registered user creates one month subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user visits the subscribe page
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user's email should be in the Loot Crate Master List bucket in sailthru
            And the user's email should have a subscription status of active in sailthru
