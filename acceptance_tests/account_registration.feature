@core @regression @account @selenium
Feature:Account Registration 
    @ready @sign
    Scenario:Valid signup through signup page. 
        Given an unregistered user
            When the user visits the signup page
            And the user submits valid signup information
        Then the user should be on the lootcrate_subscribe page
            And the user should be logged in 
            # TODO :And the database entry for the user should be created
    @ready @modal
    Scenario: Valid signup through the modal
        Given an unregistered user
            When the user visits the homepage
            And the user joins through the modal
            Then the user should be logged in
    @ready 
    Scenario: User attempts to register and account using invalid signup data
        Given an unregistered user
            When the user visits the signup page
            And the user submits invalid signup information
         Then signup should not succeed

    @ready @krisdev
    Scenario: User can reset password via the forgot password link
        Given an registered user with an active sub
            When resets their password through the modal
            And The user clicks on the reset link in their email
        Then the user should be able to reset their password
