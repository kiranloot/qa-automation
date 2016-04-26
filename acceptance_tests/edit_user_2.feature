@core @regression @account @selenium
Feature: User Detail Editing
    @ready @safari_ready @mobile_ready
    Scenario: Verify the variants dropdown in Edit Sub Info panel has no blank or nil entries
        Given    a registered user with an active subscription
            When the user logs in
            And  the user visits the my account page
            And  goes to the edit subscription info section
        Then     the list of subscription variants should have no blank or nil options
