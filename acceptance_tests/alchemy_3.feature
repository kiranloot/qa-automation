@regression @core @alchemy @selenium
Feature: Alchemy CMS
    @ready @alchemy_text
    Scenario Outline: Validate firefly/lcdx theme page publish
        Given an alchemy user
            When the user visits the alchemy page
            And the alchemy user logs into alchemy
            And the user edits the <alchemy_page> page
            And changes the <essence> basic text field to a random string and stores the original
            And the user saves the alchemy page
            And the user publishes the alchemy page
            And the user visits the <page> page
        Then the user should see the new alchemy content on the page
        Examples:
        | alchemy_page                | essence                | page               |
        | firefly-crate_monthly_theme | Divider label title    | firefly_landing    |
        | lcdx-crate_monthly_theme    | Divider label title    | lcdx_landing       |
