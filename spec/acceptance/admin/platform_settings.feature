Feature: Sign in
  In order that several aspects of the platform will have to be configurable
  As a registered admin
  I want to be able to edit platform settings

  Background:
    Given I exist as admin
    And I am signed in as admin
    And Platform settings exist

  Scenario: Admin views platform settings
    When I go to platform settings page
    Then I should see platform settings

  @javascript
  Scenario: Admin changes settings
    When I go to edit platform settings page
    And I change platform settings
    Then I should see platform settings changed
