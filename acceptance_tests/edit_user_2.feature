@core @regression @account @selenium
Feature: User Detail Editing
    @ready @safari_ready @mobile_ready
    Scenario: The user edits their subscription's subscription info
        Given    a registered user with an active subscription
            When the user logs in
            And  the user visits the my account page
            And  goes to the edit subscription info section
        Then     the list of subscription variants should have no blank or nil options
