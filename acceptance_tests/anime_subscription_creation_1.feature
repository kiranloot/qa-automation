@regression @core @anime_subscription_creation @selenium
Feature: Anmie Subscription Creation
    @ready @recurly @mobile_ready
    Scenario: Registered user creates one month anime subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Anime crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a anime confirmation email
            And the recurly subscription data is fully validated

    @ready @safari_ready
    Scenario: Registered user creates three month anime subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the Anime crate
            And the user selects a three month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
        And the recurly subscription should have the correct rebill date

    @ready @recurly
    Scenario: Registered user creates six month anime subscription
        Given a registered user with no prior Subscription
            When the user logs in
            And the user selects the Anime crate
            And the user selects a six month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
            And recurly should have a matching subscription
