Feature: Feature visibility
  In order to decouple feature visibility from code deployments
  As a webmaster (oh yeah)
  I want to use Dolphin to determine the visibility of features in my app

  Scenario: Test app sanity check
    When I go to the home page
    Then I should see "Hello"

  Scenario: Using the bundled flippers
    Given I have the following features:
      | name    | flipper  |
      | awesome | enabled  |
      | secrets | disabled |
    When I go to the home page
    Then I should see "Awesome"
    And I should not see "Secrets"

  Scenario: Using configured flippers
    Given I have the following features:
      | name     | flipper |
      | tunafish | tuna    |
    When I go to the home page
    Then I should see "MMM, TUNA"

  Scenario: Using the partial form of the helper
    Given I have the following features:
      | name    | flipper |
      | partial | enabled |
    When go to the home page
    Then I should see "I am partial"

  Scenario: Passing options to the partial
    Given I have the following features:
      | name                 | flipper |
      | partial_with_options | enabled |
    When go to the home page
    Then I should see "Hear me"

  @silence
  Scenario: An error in the flipper fails silently and is falsy
    Given I have the following features:
      | name   | flipper |
      | busted | broken  |
    When I go to the broken flipper page
    Then I should not see "Broken flipper"
    And I should see "Hello"
