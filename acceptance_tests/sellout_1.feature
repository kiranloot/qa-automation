@regression @core @sellout @selenium
Feature: Sellouts 
    @ready @anime_inv_sellout
    Scenario: A single size sells out for anime
        Given an unregistered user
        And the anime-crate-mens-s-shirt variant is sold out
            When the user logs in
            And the user selects the Anime crate
            And the user selects a one month subscription plan
        Then the Mens - S option should be soldout 

    @ready @anime_inv_sellout
    Scenario: The anime crate sells out
        Given an unregistered user
        And the Anime Crate product is sold out
            When the user logs in
            And the user selects the Anime crate
        Then the landing page should reflect the sellout

    @sellout_ready
    Scenario: A single size sells out for pets
        Given an unregistered user
        And the pets-crate-dog-xxl-shirt variant is sold out
            When the user logs in
            And the user selects the Pets crate
            And the user selects a one month subscription plan
        Then the Dog - XXL option should be soldout

    @sellout_ready
    Scenario: The pets crate sells out
        Given an unregistered user
        And the Pets Crate product is sold out
            When the user logs in
            And the user selects the Pets crate
        Then the landing page should reflect the sellout

    @sellout_ready
    Scenario: A single size sells out for core crate
        Given an unregistered user
        And the core-crate-womens-l-shirt variant is sold out
            When the user logs in
            And the user selects the Loot Crate crate
            And the user selects a one month subscription plan
        Then the Womens - L option should be soldout

    @sellout_ready
    Scenario: The core crate sells out
        Given an unregistered user
        And the Core Crate product is sold out
            When the user logs in
            And the user selects the Loot Crate crate
        Then the landing page should reflect the sellout

    @sellout_ready
    Scenario: A single size sells out for level up
        Given an unregistered user
        And the level-up-tshirt-crate-mens-l-shirt variant is sold out
            When the user logs in
            And the user selects the Level Up crate
        Then the Mens - L option for level up tshirt should be soldout
