@time_based_tests
Feature: Rebilling validation tests
    @time_based_validation
    Scenario: Verify a successful rebill
        Given there is a successfull_rebill.yml file in the tmp dir
        Then the recurly account should have 2 invoices
        And the recurly account's last invoice should be collected
        And the subscriptions rebill date should be adjusted by 1 month
        And the subscription's status should be Active

    @time_based_validation
    Scenario: Verify a past due rebill
        Given there is a past_due_rebill.yml file in the tmp dir
        Then the recurly account should have 2 invoices
        Then the recurly account's last invoice should be past_due
        And the subscriptions rebill date should be adjusted by 1 month
        And the subscription's status should be Past Due

    @time_based_validation
    Scenario: Verify an expired rebill
        Given there is a expired_rebill.yml file in the tmp dir
        And the subscriptions rebill date should be adjusted by 0 month
        Then the subscription's status should be Canceled
