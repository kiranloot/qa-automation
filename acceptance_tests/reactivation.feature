Feature: Subscription reactivation
    @ready @recurly
    Scenario: User reactivates cancelled subscription
        Given a registered user with a canceled subscription
            When the user logs in
            And the user visits the my account page
            And the user reactivates their subscription
        Then the reactivation should be reflected in the user account
            And the subscription should be successfully reactivated in the admin panel
            And the recurly subscription should be active

    Scenario: User reactivates cancelled subscription with promotion code
      Given   a registered user with a canceled subscription
      And     has a multi use reactivation promo code for 12 percent off
        When    the user logs in
        And     the user visits the my account page
        And     the user reactivates their subscription
    Then  the reactivation should be reflected in the user account
    And   the subscription should be successfully reactivated in the admin panel
    And   the recurly subscription should be active
    And   the recurly coupon is correctly created
    And   the last invoice has the discount
