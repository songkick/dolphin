Feature: Updating features
  In order to decouple feature visibility from code deployments
  As a webmaster (oh yeah)
  I want to be able to change the visibility of a feature at runtime

  Scenario: Feature is not visible before changing the flipper
    Given I have the following features:
      | name    | flipper  |
      | secrets | disabled |
    When I go to the home page
    Then I should not see "Secrets"

  Scenario: Changing the flipper should affect the visibility
    Given I have the following features:
      | name    | flipper  |
      | secrets | disabled |
    When I set the flipper for feature "secrets" to "enabled"
    And I go to the home page
    Then I should see "Secrets"
