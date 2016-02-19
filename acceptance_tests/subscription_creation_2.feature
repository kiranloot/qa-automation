@regression @core @subscription_creation @selenium
Feature: Subscription Creation
    @ready @mobile_ready
    Scenario: Registered user creates twelve month subscription plan
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready @mobile_ready
    Scenario: User attempts to create a subscription with invalid credit
        card data
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a random month subscription plan
            And the user submits invalid subscription information
        Then subscription creation should fail due to invalid credit card


    @ready @recurly @mobile_ready
    Scenario: User with different billing info purchases a subscription
        Given a registered user with no prior Subscription
        And   a different billing address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a six month subscription plan
            And the user submits valid subscription and billing information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
            And the recurly subscription data is fully validated
