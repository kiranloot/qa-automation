@webhooks
Feature: Ensure Recurly Webhooks all complete successfully
    @webhooks_indev
    Scenario: All Recurly Webhooks associated with subscription creation complete successfully
        Given a registered user with no prior subscription
            When the user logs in
            And the user visits the subscribe page
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the webhooks fired during subscription creation should all have a status of completed_successfully
