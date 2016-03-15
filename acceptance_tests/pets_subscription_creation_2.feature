@regression @core @pets_subscription_creation @selenium
Feature: Pets Subscription Creation
    @ready @mobile_ready
    Scenario: Registered user creates twelve month pets subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Pets crate
            And the user selects a twelve month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a pets confirmation email
            And the recurly subscription should have the correct rebill date

    @ready @mobile_ready
    Scenario: International user signs up for random month pets subscription
        Given a registered user with a Austria address
            When the user logs in
            And the user selects the Pets crate
            And the user sets their country to Austria
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a pets confirmation email

    @ready @recurly
    Scenario: User upgrades from one month to three month subscription plan
        Given a registered user with a pets one month subscription
        And   the user notes the recurly rebill date
            When the user logs in
            And  the user visits the my account page
            And  the user upgrades to a three month subscription
        Then the new subscription should be added to the user account
        And  the user should receive an upgrade email
        And  recurly should now have a three month subscription plan
        And  the recurly account's last transaction should have tax calculated
        And  the recurly rebill date should be 2 months ahead
