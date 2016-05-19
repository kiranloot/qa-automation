@tax
Feature: Tax Calculation
    @ready
    Scenario: A Texas user is charged tax when checking out
        Given a registered user with a Texas Address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user is displayed the correct tax
            And the recurly account's last transaction should have tax calculated

    @ready
    Scenario: A Vermont user is charged tax when checking out
        Given a registered user with a Vermont Address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user is displayed the correct tax
            And the recurly account's last transaction should have tax calculated

    @ready
    Scenario: A South Carolina user is charged tax when checking out
        Given a registered user with a South_Carolina address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the user is displayed the correct tax
            And the recurly account's last transaction should have tax calculated
