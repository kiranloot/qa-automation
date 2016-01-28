@unskip
Feature: Unskip a Month
    @ready
    Scenario: unskip an already skipped core crate subscription
        Given a registered user with a one month subscription
            When the user logs in
	            And the user visits the my account page
	            And the user skips during cancellation
	            And the subscription status should be set to active with a skip
              And the user notes the recurly rebill date
	            And the user clicks unskip
            Then the subscription status should not be skipped
            	And the user should receive a unskip email
              And the recurly rebill date should be 1 month behind

    @ready @skipdev
    Scenario: unskip an already skipped level up subscription
        Given a registered user with an active level up subscription
            When the user logs in
	            And the user visits the my account page
	            And the user skips during cancellation
	            And the subscription status should be set to active with a skip
              And the user notes the recurly rebill date
	            And the user clicks unskip
            Then the subscription status should not be skipped
            	And the user should receive a unskip email
              And the recurly rebill date should be 1 month behind
