@regression @core @pets_subscription_creation @selenium
Feature: Pets Subscription Creation
    @ready
    Scenario: Registered user creates twelve month pets subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Pets crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a pets confirmation email
