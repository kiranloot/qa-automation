@regression @core @anime_subscription_creation @selenium
Feature: Anime Subscription Creation
    @ready
    Scenario: Registered user creates twelve month anime subscription plan
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Anime crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then standard new subscription pass criteria should pass

    @ready @mobile_ready
    Scenario: International user signs up for random month Anime subscription
        Given a registered user with a Austria address
            When the user logs in
            And the user selects the Anime crate
            And the user sets their country to Austria
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a anime confirmation email
