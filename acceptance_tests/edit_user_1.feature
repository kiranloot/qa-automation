@account
Feature: User Detail Editing
    @ready @recurly @safari_ready @mobile_ready
    Scenario: The user edits their subscription's shipping address
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their shipping address
        Then the updated shipping information should be reflected when the user views the subscription
            And the recurly shipping address should be updated
            And the correct subscription information should be displayed in the admin panel


    @ready @recurly @safari_ready @mobile_ready
    Scenario: The user edits their subscription's billing address
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their billing information
        Then the billing address change should be reflected in the user account
            And the recurly billing address should be updated
            And the correct subscription billing information should be displayed in the admin panel
            

    @ready @safari_ready @mobile_ready
    Scenario: The user edits their subscription's subscription info
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel
