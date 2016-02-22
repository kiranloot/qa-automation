@regression @core @sailthru @selenium
Feature: Sailthru Integration
    @ready
    Scenario: Sailthru update on new Level Up subscriber
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Level Up crate
            And the user selects a level up six month subscription for the accessory crate
            And the user submits valid subscription information
        Then the user's email should have a Level Up subscription status of active in sailthru

    @ready
    Scenario: Verify sailthru creation via newsletter modal
    	Given an unregistered user
        And the user's email does not exist in sailthru
        When the user waits for the newsletter modal to appear
        And the user joins through the newsletter modal
      Then the user's email should be in the Loot Crate Master List bucket in sailthru

    @ready
    Scenario: Valid signup through the Loot Crate join modal
    	Given an unregistered user
        And the user's email does not exist in sailthru
      	And the user joins through the modal
    	Then the user's email should be in the Loot Crate Master List bucket in sailthru
