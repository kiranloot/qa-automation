@regression @core @sellout @selenium
Feature: Anime sellouts 
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

    @ready @anime_inv_sellout
    Scenario: User goes to one page checkout for a sold out crate
        Given an unregistered user
        And   the Anime Crate product is sold out
            When the user visits the anime_opc page
        Then the opc page should reflect the sellout

    @ready @anime_inv_sellout
    Scenario: User goes to one page checkout for a sold out variant
        Given an unregistered user
        And   the anime-crate-mens-s-shirt variant is sold out
            When the user visits the anime_opc page
        Then the Mens - S option should be soldout
        