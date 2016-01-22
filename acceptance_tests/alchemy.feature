@regression @core @alchemy @selenium
Feature: Alchemy CMS
    @ready @krisdev
    Scenario: Check an alchemy text publish
        Given an alchemy user
            When the user visits the alchemy page
            And the alchemy user logs into alchemy
            And the user edits the about_us page
            And changes the About us title text to a random string
            And the user saves the alchemy page
            And the user publishes the alchemy page
            And the user visits the about_us page
        Then the user should see the new alchemy content on the page
