@memory
Feature: Page around the site for an extended period to test memory usage
    Scenario: Log in and dance around to check memory
        Given a registered user with no prior subscription
            When the user logs in
            And we do the memory dance for 4 minutes
        Then check the memory usage out

