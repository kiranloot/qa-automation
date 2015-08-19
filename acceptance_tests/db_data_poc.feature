Feature: Proof of concept for getting test data from the database, if it's there. 
    Scenario: Get an active subscription from the database, if there. If not, make one.
        Given an example user with an active subscription
            When the user logs in
        Then user data should match the UI