@subscription_creation
Feature: Subscription Creation - One Page Checkout
    @ready @safari_ready
    Scenario Outline: Unregistered user creates one month core/anime/gaming subscription using one page checkout
        Given an unregistered user
            When the user visits the <page> page
            And the user selects a one month subscription plan
            And the user submits valid signup information
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a <email_type> email
            And the recurly subscription should have the correct rebill date
        Examples:
        | page       | email_type                |
        | core_opc   | subscription confirmation |
        | anime_opc  | anime confirmation        |
        | gaming_opc | gaming confirmation       |
