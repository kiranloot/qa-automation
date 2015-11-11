@regression @core @subscription_creation @selenium
Feature: Subscription Creation
    @ready
    Scenario: Registered user creates one month subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a subscription confirmation email

    @ready 
    Scenario: Registered user creates three month subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user visits the subscribe page
            And the user selects a three month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready @recurly
    Scenario: Registered user creates six month subscription
        Given a registered user with no prior Subscription
            When the user logs in 
            And the user visits the subscribe page
            And the user selects a six month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
