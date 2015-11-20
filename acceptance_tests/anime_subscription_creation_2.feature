@regression @core @anime_subscription_creation @selenium
Feature: Subscription Creation
    @ready
    Scenario: Registered user creates twelve month anime subscription plan
        Given a registered user with no prior subscription 
            When the user logs in
            And the user selects the Anime crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass
