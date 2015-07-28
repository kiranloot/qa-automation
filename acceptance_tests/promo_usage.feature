@regression @core
Feature: Promotion codes
    @ready
    Scenario: User applies valid multi use promo code at signup.
        Given a registered user with a multi use promo code
            When the user logs in
            And the user visits the subscribe page
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the promo discount should be applied to the transaction
            And the new subscription should be added to the user account


