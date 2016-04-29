@regression @core @dx_subscription_creation @dx_inv_req @selenium
Feature: DX Subscription Creation
    @ready @recurly 
    Scenario: Registered user creates a one month dx crate subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the DX crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a dx confirmation email
            And the recurly subscription data is fully validated

    @ready @safari_ready
    Scenario: Registered user creates three month dx subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the DX crate
            And the user selects a three month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
        And the recurly subscription should have the correct rebill date

    @ready @recurly
    Scenario: Registered user creates six month dx subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the DX crate
            And the user selects a six month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
