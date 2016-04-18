@regression @core @alchemy @selenium
Feature: Alchemy CMS
    @ready @alchemy_text
    Scenario: Check an alchemy text publish
        Given an alchemy user
            When the user visits the alchemy page
            And the alchemy user logs into alchemy
            And the user edits the about_us page
            And changes the About us title rich text field to a random string and stores the original
            And the user saves the alchemy page
            And the user publishes the alchemy page
            And the user visits the about_us page
        Then the user should see the new alchemy content on the page

    @ready @alchemy_text
    Scenario: Validate header carousel in Alchemy
        Given an alchemy user
            When the user visits the alchemy page
            And the alchemy user logs into alchemy
            And the user edits the front_page_slider page
        Then the user should not see any errors in the alchemy preview pane

    @ready @alchemy_text
    Scenario: Validate anime theme page publish
        Given an alchemy user
            When the user visits the alchemy page
            And the alchemy user logs into alchemy
            And the user edits the anime-crate_monthly_theme page
            And changes the Web theme title rich text field to a random string and stores the original
            And the user saves the alchemy page
            And the user publishes the alchemy page
            And the user visits the anime_landing page
        Then the user should see the new alchemy content on the page
