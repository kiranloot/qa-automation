@regression @core @sellout @selenium
Feature: Anime sellouts 
    @ready @anime_inv_sellout
    Scenario: User goes to one page checkout for a sold out variant
        Given an unregistered user
        And   the anime-crate-mens-s-shirt variant is sold out
            When the user visits the anime_opc page
        Then the Mens - S option should be soldout 