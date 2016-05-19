@regression
Feature: Product page redirect
    @ready
    Scenario: Registered user tries to navigate to a checkout page for an unknown product
        Given a registered user with no prior subscription
            When the user logs in
            And  navigates to an invalid checkout page
        Then  the user should be redirected to the plan selection page for core crate
