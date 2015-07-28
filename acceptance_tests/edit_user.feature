Feature: User Detail Editing
    @working
    Scenario:User edits their shipping info
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their shipping address
        Then the shipping address change should be reflected in the user account
            And the shipping address change should be reflected in the admin panel
    @wait
    Scenario:User edits their billing info
    @wait
    Scenario:User edits their credit card info