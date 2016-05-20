@ready
  #validate discount with crunchyroll primium plus account
Feature: Anime Subscription Creation with cruncyroll discount
  @cr_ready
  Scenario: Registered user creates one month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a one month subscription plan
    And the crunchyroll user login with primium plus account
    And the verify crunchyroll one month coupon applied
    And the user submits valid subscription information
    Then the new subscription should be added to the user account
    And the recurly subscription data is fully validated
    And the admin user visits the admin page
    And logs in as an admin
    And views the user's information
    And the user delete crunchyroll_link with lootcrate account
  @cr_ready
  Scenario: Registered user creates three month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a three month subscription plan
    And the crunchyroll user login with primium plus account
    And the verify crunchyroll three month coupon applied
    And the user submits valid subscription information
    Then the new subscription should be added to the user account
    And the recurly subscription data is fully validated
  @cr_ready
  Scenario: Registered user creates six month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a six month subscription plan
    And the crunchyroll user login with primium plus account
    And the verify crunchyroll six month coupon applied
    And the user submits valid subscription information
    Then the new subscription should be added to the user account
    And the recurly subscription data is fully validated
  @cr_ready
  Scenario: Registered user creates tweel month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a twelve month subscription plan
    And the crunchyroll user login with primium plus account
    And the verify crunchyroll twelve month coupon applied
    And the user submits valid subscription information
    Then the new subscription should be added to the user account
    And the recurly subscription data is fully validated

 #validate discount with crunchyroll primium account
  @cr_ready
  Scenario: Registered user creates one month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a one month subscription plan
    And the crunchyroll user login with primium account
    And the verify crunchyroll one month coupon applied
    And the user submits valid subscription information
    Then the new subscription should be added to the user account
    And the recurly subscription data is fully validated

  #Crunchyroll account already linked
  @cr_linked
  Scenario: Registered user creates one month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a one month subscription plan
    And the crunchyroll user login with primium plus account
    And the verify crunchyroll one month coupon applied
  @cr_linked
  Scenario: Registered user creates one month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a one month subscription plan
    And the crunchyroll user login with primium plus account
    And the verify crunchyroll one month coupon is not applied
   # And the admin user delete link with crunchyroll account

  #link cruncyroll account under manage account
  @cr_ready1
  Scenario: Registered user creates one month anime subscription
    Given a registered user with no prior subscription
    When the user logs in
    And the user selects the Anime crate
    And the user selects a one month subscription plan
    And the user submits valid subscription information
    And the user go to my_account
    And the user link LC account with crunchyroll account
    And the cruncyroll account is verified


