@regression @core @firefly_subscription_creation @selenium
Feature: Firefly Subscription Creation

    @ready
    Scenario Outline: User from France/Germany/Italy creates a firefly random month subscription
        Given a registered user with a <country> address
            When the user logs in
            And the user selects the Firefly crate
            And the user sets their country to <country>
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And recurly should have a matching international subscription
            And the recurly billing address should have no state
            And the user should receive a firefly confirmation email
            And the recurly subscription should have the correct rebill date
    Examples:
      | country |
      | Germany |
      | Italy   |

    @ready @mobile_ready
    Scenario Outline: User from France/Germany/Italy creates a firefly random month subscription
        Given a registered user with a <country> address
            When the user logs in
            And the user selects the Firefly crate
            And the user sets their country to <country>
            And the user selects a random month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
            And recurly should have a matching international subscription
            And the recurly billing address should have no state
            And the user should receive a firefly confirmation email
            And the recurly subscription should have the correct rebill date
    Examples:
      | country |
      | France  |
