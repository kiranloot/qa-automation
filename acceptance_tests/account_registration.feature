@account
Feature:Account Registration 
    @ready @sign @safari_ready
    Scenario:Valid signup through signup page. 
        Given an unregistered user
            When the user visits the signup page
            And the user submits valid signup information
        Then the user should be on the lootcrate_subscribe page
            And the user should be logged in 
            # TODO :And the database entry for the user should be created
    @ready @modal @safari_ready
    Scenario: Valid signup through the modal
        Given an unregistered user
            When the user visits the homepage
            And the user joins through the modal
            Then the user should be logged in
    @ready @safari_ready
    Scenario: User attempts to register and account using invalid signup data
        Given an unregistered user
            When the user visits the signup page
            And the user submits invalid signup information
         Then signup should not succeed
