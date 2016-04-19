@regression @core @alchemy @selenium
Feature: Alchemy CMS
    @ready @alchemy_text
    Scenario Outline: Validate gaming/pets/core theme page publish
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
        | alchemy_page               | essence                | page              |
        | gaming-crate_monthly_theme | Divider label subtitle | gaming_landing    |
        | pets-crate_monthly_theme   | Divider label subtitle | pets_landing      |
        | core-crate_monthly_theme   | Divider label subtitle | lootcrate_landing |
