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

    @ready
    Scenario: Registered user upgrades an existing anime subscription
        Given a registered user with an anime one month subscription
        And   the user notes the recurly rebill date
            When the user logs in
            And  the user visits the my account page
            And  the user upgrades to a three month subscription
        Then the new subscription should be added to the user account
        And  the user should receive an upgrade email
        And  recurly should now have a three month subscription plan
        And  the recurly account's last transaction should have tax calculated
        And  the recurly rebill date should be 2 months ahead
