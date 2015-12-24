@regression @core @tax @selenium
Feature: Tax Calculation
    @ready
    Scenario: A california user is charged tax when checking out
        Given a registered user with a California Address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user is displayed the correct tax

    @ready
    Scenario: A california user is charged tax when checking out
        Given a registered user with a Washington Address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user is displayed the correct tax
