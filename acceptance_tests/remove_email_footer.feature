@regression
Feature: Remove Sign Up email field from the footer for logged in user
  @ready
  Scenario Outline: Sign UP email field is removed from the footer for core and specialty crate for the logged in looter
    Given an <type> user
    When the user logs <in_out>
    And the user selects the <crate> crate
    Then the user should not see footer email field
    Examples:
      | type       | in_out | crate |
      | registered | in     | Loot Crate |
      | registered | in     | Level Up  |
      | registered | in     | Anime  |
      | registered | in     | Pets  |
      | registered | in     | Firefly®  |
      | registered | in     | Star Wars™  |
      | registered | in     | Call of Duty®  |

