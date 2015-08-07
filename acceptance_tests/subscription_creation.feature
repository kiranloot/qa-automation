@regression @core @subscription_creation @selenium
Feature: Subscription Creation
    @ready @fixing
    Scenario: Registered user creates one month subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user visits the subscribe page
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            #TODO: Add this if zoura is no-go: And the new subscription should be added to chargify
            And the user should receive a subscription confirmation email
            #TODO: And the user's data should be updated in mailchimp
    @ready 
    Scenario: Registered user creates three month subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user visits the subscribe page
            And the user selects a three month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
    @ready
    Scenario: Registered user creates six month subscription
        Given a registered user with no prior Subscription
            When the user logs in 
            And the user visits the subscribe page
            And the user selects a six month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
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
    @ready
    Scenario: User attempts to create a subscription with invalid credit 
        card data
        Given a registered user with no prior subscription
            When the user logs in 
            And the user visits the subscribe page
            And the user selects a random month subscription plan
            And the user submits invalid credit card information
        Then subscription creation should fail due to invalid credit card

    @ignore
    Scenario: User attempts to create a subscription using the express checkout
        Given a registered user with no prior subscription
            When the user logs in
            And the user visits the subscribe page
            And the user selects a random month subscription plan
            And the user visits the express checkout page
            And the user submits valid express_checkout information
        Then standard new subscription pass criteria should pass
