@regression @core @dx_subscription_creation @dx_inv_req @selenium
Feature: DX Subscription Creation
    @ready
    Scenario: Registered user creates twelve month dx subscription plan
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the DX crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready @mobile_ready
    Scenario: International user signs up for random month DX subscription
        Given a registered user with a Austria address
            When the user logs in
            And the user selects the DX crate
            And the user sets their country to Austria
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a dx confirmation email
