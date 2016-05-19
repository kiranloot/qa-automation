@regression
Feature: Subscription Upgrades
    @ready @recurly
    Scenario: User upgrades from one month to three month subscription plan
        Given a registered user with a one month subscription
        And   the user notes the recurly rebill date
            When the user logs in
            And  the user visits the my account page
            And  the user upgrades to a three month subscription
        Then the new subscription should be added to the user account
        And  the user should receive an upgrade email
        And  recurly should now have a three month subscription plan
        And  the recurly account's last transaction should have tax calculated
        And  the recurly rebill date should be 2 months ahead

    Scenario: User presented with price and proration details before upgrade from 1 to 12 month subscription plan
        Given a registered user with a one month subscription
            When the user logs in
              And the user visits the upgrade page
            Then the user is shown the correct product price
              And the user is shown the correct prorated amount
              And the user is shown the correct payment due

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
