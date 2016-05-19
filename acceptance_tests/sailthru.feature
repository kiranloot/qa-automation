@regression @core @sailthru @selenium
Feature: Sailthru Integration
    @ready
    Scenario: Creating a sub should submit the user's email to sailthru
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user's email should be in the Loot Crate Master List bucket in sailthru
            And the user's email should have a subscription status of active in sailthru

    @ready @anime_inv_req
    Scenario: Sailthru update on new Anime subscriber
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Anime crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user's email should have an Anime subscription status of active in sailthru

    @ready @pets_inv_req
    Scenario: Sailthru update on new Pets subscriber
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Pets crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user's email should have a Pets subscription status of active in sailthru
