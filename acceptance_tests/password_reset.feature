@regression @password @extended
Feature: Password reset
    @broken
    Scenario: User resets their password using forgot password flow
        Given a registered user that is logged out
            When the user visits the homepage
            And requests a password reset
            And attempts to reset their password using the emailed reset link
        Then the user should be able to log in with their new password