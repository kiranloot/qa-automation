@password @extended
Feature: Password reset
    @ready
    Scenario: User can reset password via the forgot password link
        Given an registered user with no prior subscription
            When the user logs in
            And the user logs out
            And the user resets their password through the modal
            And The user clicks on the reset link in their email
            And the user enters a new password
        Then the user should be able to login with their new password
