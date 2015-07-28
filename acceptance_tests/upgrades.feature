@core @regression
Feature: Subscription Upgrades
    @ready
    Scenario: User upgrades from one month to three month subscription plan
        Given a registered user with a one month subscription
            When the user logs in 
            And the user visits the my account page
            And the user upgrades to a three month subscription
        Then the new subscription should be added to the user account
            And the user should receive an upgrade email 


    Scenario: User presented with price and proration details before upgrade from 1 to 12 month subscription plan
      Given a registered user with a one month subscription
      When the user logs in
        And the user visits the upgrade page
      Then the user is shown the correct product price
        And the user is shown the correct prorated amount
        And the user is shown the correct payment due
