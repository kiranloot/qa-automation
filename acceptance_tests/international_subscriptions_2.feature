@regression @extended @world_subs @selenium
Feature: International Subscriptions
    @ready
    Scenario: Belgium user signs up for one month subscription
        Given a registered user with a Belgium address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user sets their country to Belgium
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And recurly should have a matching international subscription
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: Canada user signs up for one month subscription
      Given a registered user with a Canada address
        When the user logs in
        And the user selects the Loot Crate crate
        And the user sets their country to Canada
        And the user selects a one month subscription plan
        And the user submits valid subscription information
      Then the new subscription should be added to the user account
      And recurly should have a matching international subscription
      And the recurly billing address should have the correct state
      And the user should receive a subscription confirmation email

    @ready
    Scenario: Czech Republic user signs up for one month subscription
      Given a registered user with a Czech address
        When the user logs in
        And the user selects the Loot Crate crate
        And the user sets their country to Czech Republic
        And the user selects a one month subscription plan
        And the user submits valid subscription information
      Then the new subscription should be added to the user account
      And recurly should have a matching international subscription
      And the recurly billing address should have no state
      And the user should receive a subscription confirmation email 
