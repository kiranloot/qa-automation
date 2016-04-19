@regression @core @subscription_creation @selenium
Feature: Subscription Creation
    @ready @safari_ready
    Scenario Outline: Unregistered user creates one month subscription
        Given an unregistered user
            When the user visits the <page> page
            And the user selects a one month subscription plan
            And the user submits valid signup information
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a <email_type> email
            And the recurly subscription should have the correct rebill date
        Examples:
        | page   | email_type                |
        | core   | subscription confirmation |
        | anime  | anime confirmation        |
        | gaming | gaming confirmation       |
