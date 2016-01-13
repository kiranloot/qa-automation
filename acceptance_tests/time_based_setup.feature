@time_based_setup
Feature: Rebilling setup actions
    @kristime_test
    Scenario: Setup a subscription to be rebilled during its rebill date
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
            And the recurly rebill date is pushed 1 minute into the future
        Then write this subscription's information into a file named successfull_rebill.yml in the tmp dir

    Scenario: Setup a past due subscription
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
            And the user submits valid subscription information
            And the recurly credit card information is modified to be declined
            And the recurly rebill information is modified to rebill in the next hour
        Then write this subscription's information into a file named past_due_rebill.yml in the tmp dir

    #TO DO:
    #Scenario: A subscription skipped right before it's rebill date will still get charged
    #Scenario: A subscription skipped right after it's rebill date will still get charged
    #Scenario: A subscription cancelled right before it's rebill date will not get charged
    #Scenario: A subscription cancelled right after it's rebill date will not get charged
