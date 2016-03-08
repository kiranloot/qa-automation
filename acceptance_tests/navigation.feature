@core @regression @account @selenium
Feature: Navigation checks
    @ready @sign @safari_ready
    Scenario: Check link integrity on home page
        Given an unregistered user
            When the user visits the homepage
            Then the user checks that all links are valid and responding properly
