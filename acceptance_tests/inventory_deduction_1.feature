@regression @core @inventory_checks @selenium
Feature: Total committed invention increases by one when customer checks out
    @ready @anime_inv_check
    Scenario: Total committed increases when customer purches an anime crate
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Anime crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the total committed anime crates should increase by one
