@core @regression @account @selenium
Feature: User Detail Editing
    @WIP
    Scenario: The user edits their subscription's shipping address
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their shipping address
        Then the shipping address change should be reflected in the user account
            And the shipping address change should be reflected in the admin panel

    @WIP
    Scenario: The user edits their subscription's billing address
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their billing address
        Then the billing address change should be reflected in the user account
            And the billing address change should be reflected in the admin panel

    @ready @indev
    Scenario: The user edits their subscription's subscription info
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel

    @WIP
    Scenario: The user edits their account information
        Given a registered user with no prior subscription
            When the user logs in
            And the user edits their account information
        Then the account info change should be reflected in the user acount
            And the account info change should be reflected in the admin panel
            And the user should still be able to login
