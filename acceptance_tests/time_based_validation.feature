@time_based_validation
Feature: Rebilling validation tests
    @kristime_validation
    Scenario: Verify a successful rebill
        Given there is a successfull_rebill.yml file in the tmp dir
        Then the recurly account should have 2 invoices
        And the recurly account's last invoice should be successfull
        And the subscriptions rebill date should be adjusted by 1 month

    Scenario: Verify a past due rebill
        Given there is a past_due_rebill.yml file in the tmp dir
        Then the recurly account's last invoice should be past due
        And the subscriptions rebill date should not be adjusted
