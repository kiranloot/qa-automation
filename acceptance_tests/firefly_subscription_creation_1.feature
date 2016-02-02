@regression @core @firefly_subscription_creation @selenium
Feature: Firefly Subscription Creation
    @ready @kris_dev
    Scenario: Registered user creates a firefly two month subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Firefly® crate
            And the user selects a two month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a firefly confirmation email
            And the recurly subscription should have the correct rebill date

    @ready @mobile_ready
    Scenario: Registered user creates three month subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a three month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready @recurly @mobile_ready
    Scenario: Registered user creates six month subscription
        Given a registered user with no prior Subscription
            When the user logs in 
            And the user selects the Loot Crate crate
            And the user selects a six month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
            And the recurly subscription data is fully validated
