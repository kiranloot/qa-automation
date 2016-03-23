@selenium @regression @admin
Feature: Admin Shipping Manifests
    @ready
    Scenario: Ensure shipping manifest page loads
        When the admin user visits the admin page
            And logs in as an admin
            And view the shipping manifests page
        Then the shipping manifests page should load

    Scenario: Admin can download the shipping manifest
      Given   the admin user visits the admin page
      And     logs in as an admin
        When  view the shipping manifests page
        And   clicks on the Request Shipping Manifest CSV button (verify 'scheduled' toast)
        And   clicks on the Shipping Manifest CSV List button
        And   verifies that the top entry's aasm state is 'completed_successfully'
        And   clicks 'view' for the manifest
        And   clicks the Download button
      Then    the downloaded file should be present in the downloads folder
