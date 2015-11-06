@regression @extended @world_subs @selenium
Feature: International Subscriptions
    #rebill date not working - Month is in Finnish
    @WIP
    Scenario: Finland user signs up for one month subscription
        Given a registered user with a Finland address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Finland
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    @ready
    Scenario: France user signs up for one month subscription
        Given a registered user with a France address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to France
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email

    #since germany is translated, the plan name "1 Month Subscription"
    #validation is failing.  Need to fix.
    @WIP
    Scenario: Germany user signs up for one month subscription
        Given a registered user with a Germany address
            When the user logs in
            And the user visits the subscribe page
            And the user sets their country to Germany
            And the user selects a one month subscription plan
            And the user submits valid subscription information
        Then the new subscription should be added to the user account
        And the recurly billing address should have no state
        And the user should receive a subscription confirmation email
