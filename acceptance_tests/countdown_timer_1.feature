@regression @core @subscription_creation @selenium
Feature: Countdown Timers
    @KrisCWIP
    Scenario: Verify countdown timer for core crate
        Given a registered user with no prior subscription
            When the user logs in
            And the user selects the Loot Crate crate
            Then the countdown timer should be working
