Feature: Proof of concept for UserGen object
    @gen
    Scenario: Configure a new user object with UserGen
        Given a user via UserGen with an active subscripiton
            When the user logs in
        Then the new subscription should be added to the user account