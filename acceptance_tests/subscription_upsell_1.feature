@regression @core @subscription_creation @selenium
Feature: Subscription Creation
    @ready
    Scenario Outline: Registered user upsold to longer subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user chooses a <months> month subscription upgrade
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And the user should receive a subscription confirmation email
            And the recurly subscription should have the correct rebill date
    Examples:
        | months |
        | three  |
        | six    |
        | twelve |
