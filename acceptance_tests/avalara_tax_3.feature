@regression @core @tax @selenium
Feature: Tax Calculation
    @ready
    Scenario: A Florida user is charged tax when checking out
        Given a registered user with a Florida Address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        #Then the user is displayed the correct tax
            And the recurly account's last transaction should have tax calculated

    @ready
    Scenario: A Pennsylvania user is charged tax when checking out
        Given a registered user with a Pennsylvania Address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        #Then the user is displayed the correct tax
            And the recurly account's last transaction should have tax calculated

    @ready
    Scenario: An Arizona user is charged tax when checking out
        Given a registered user with an Arizona address
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        #Then the user is displayed the correct tax
            And the recurly account's last transaction should have tax calculated
