@Regression @currency @extended
Feature: Currency labelling and Markup
    Scenario: Denmark User should see localized price estimates.
        Given a Denmark user with no prior subscription
            When the user logs in
            And the user changes their country to Denmark
            And the user visits the subscribe page
        Then the local currency estimate for Denmark should be displayed

    Scenario: Denmark User should see USD sign on price totals during checkout
        Given a Denmark user with no prior subscription
            When the user logs in
            And the user changes their country to Denmark
            And the user visits the subscribe page
            And the enters valid subscription information
        Then the today's price totals should display the USD sign
            And the purchase total should display the USD sign