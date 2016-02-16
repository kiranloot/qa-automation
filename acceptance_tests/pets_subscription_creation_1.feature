@regression @core @pets_subscription_creation @selenium
Feature: Pets Subscription Creation
    @ready
    Scenario: Registered user creates one month pets subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Pets crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a pets confirmation email

    @ready
    Scenario: Registered user creates three month pets subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the Pets crate
            And the user selects a three month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready @recurly @safari_ready
    Scenario: Registered user creates six month pets subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the Pets crate
            And the user selects a six month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
