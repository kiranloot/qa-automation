@regression @core @sellout @selenium
Feature: Gaming sellouts 
    @ready @gaming_inv_sellout
    Scenario: User goes to one page checkout for a sold out variant
        Given an unregistered user
        And   the gaming-crate-mens-s-shirt variant is sold out
            When the user visits the gaming_opc page
        Then the Mens - S option should be soldout 