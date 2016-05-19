Feature: Subscription Upgrades
    @ready @recurly @kris_indev
    Scenario: User upgrades an international subscription
        Given a registered user with an international one month subscription
        And   the user notes the recurly rebill date
            When the user logs in
            And  the user visits the my account page
            And  the user upgrades to a three month subscription
        Then the new subscription should be added to the user account
        And  the user should receive an upgrade email
        And  recurly should now have a three month subscription plan
        And  the recurly account's last transaction shouldn't have tax calculated
        And  the recurly rebill date should be 2 months ahead
