@core @regression @account @selenium
Feature: User Detail Editing
    @ready @safari_ready @mobile_ready
    Scenario: Verify the variants dropdown in Edit Sub Info panel has no blank or nil entries
        Given    a registered user with an active subscription
            When the user logs in
            And  the user visits the my account page
            And  goes to the edit subscription info section
        Then the list of subscription variants should have no blank or nil options

    @ready @anime_inv_req
    Scenario: The user edits their anime subscriptions subscription info
        Given a registered user with an active anime subscription
            When the user logs in
            And the user edits their subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel

    @ready @gaming_inv_req
    Scenario: The user edits their gaming subscriptions subscription info
        Given a registered user with an active gaming subscription
            When the user logs in
            And the user edits their subscription info
        Then the updated information should be reflected when the user views the subscription
            And the subscription information change should be reflected in the admin panel
