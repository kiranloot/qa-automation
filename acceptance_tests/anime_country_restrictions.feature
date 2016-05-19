@anime_country_restrictions
Feature: Singapore, South Korea and Japan blocked from buying anime crate
    @ready
    Scenario Outline: A user with a Singapore/South Korea/Japan address cannot purchase the anime crate
        Given a registered user with no prior subscription
            When the user logs in
            And the user sets their country to <country>
            And the user selects the Anime crate
        Then the user should be redirected to the plan unavailable page
        Examples:
        | country     |
        | Japan       |
        | South Korea | 
        | Singapore   |
