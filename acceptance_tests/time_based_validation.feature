@time_based_validation
Feature: Rebilling validation tests
    Scenario: Verify a successful rebill
        Given there is a successfull_rebill.yml file in the tmp dir
        Then the recurly account's last invoice should be successfull
        And the subscriptions rebill date should be adjusted

    Scenario: Verify a past due rebill
        Given there is a past_due_rebill.yml file in the tmp dir
        Then the recurly account's last invoice should be past due
        And the subscriptions rebill date should not be adjusted
