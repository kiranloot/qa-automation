@regression @core @anime_subscription_creation @selenium
Feature: DX Subscription Creation
    @ready @recurly @kris_dev
    Scenario: Registered user creates dx crate subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the DX crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a dx confirmation email
            And the recurly subscription data is fully validated
