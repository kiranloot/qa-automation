@webhooks
Feature: Ensure Recurly Webhooks all complete successfully
    @ready
    Scenario: All Recurly Webhooks associated with subscription creation complete successfully
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the webhooks fired during subscription creation should all have a status of completed_successfully

    @ready
    Scenario: All Recurly Webhooks associated with cancellation complete successfully
        Given a registered user with an active subscription
            When the user logs in
            And the user visits the my account page
            And the user cancels their subscription
        Then the webhooks fired during cancellation should all have a status of completed_successfully

    @ready
    Scenario: All Recurly Webhooks associated with editing billing address complete successfully
        Given a registered user with an active subscription
            When the user logs in
            And the user edits their billing information
        Then the webhooks fired during editing billing address should all have a status of completed_successfully
