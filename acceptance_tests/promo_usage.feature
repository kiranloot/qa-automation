Feature: Promotion codes
    @ready
    Scenario: User applies valid multi use promo code at signup.
        Given a registered user with a multi use fixed promo code
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the promo discount should be applied to the transaction
            And the new subscription should be added to the user account
            And the recurly coupon is correctly created
            And the last invoice has the discount

    @ready
    Scenario: User applies valid one time use promo code at signup
        Given a registered user with a one time use percentage promo code
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the promo discount should be applied to the transaction
            And the new subscription should be added to the user account
            And the recurly coupon is correctly created
            And the last invoice has the discount
