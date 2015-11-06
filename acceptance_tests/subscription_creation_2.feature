@regression @core @subscription_creation @selenium
Feature: Subscription Creation
    @ready
    Scenario: Registered user creates twelve month subscription plan
        Given a registered user with no prior subscription 
            When the user logs in
            And the user visits the subscribe page
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready
    Scenario: California registered user creates a subscription
        Given a registered user with a California Address
            When the user logs in
            And the user visits the subscribe page
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then sales tax should be applied to the transaction price
            And standard new subscription pass criteria should pass
            And the recurly billing address should have the correct state

    @ready
    Scenario: User attempts to create a subscription with invalid credit 
        card data
        Given a registered user with no prior subscription
            When the user logs in 
            And the user visits the subscribe page
            And the user selects a random month subscription plan
            And the user submits invalid credit card information
        Then subscription creation should fail due to invalid credit card
