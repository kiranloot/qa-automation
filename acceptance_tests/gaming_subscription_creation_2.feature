@regression @core @gaming_sub_creation @selenium
Feature: Subscription Creation
    @ready
    Scenario: Registered user creates twelve month gaming subscription plan
        Given a registered user with no prior subscription 
            When the user logs in
            And the user selects the Gaming crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
