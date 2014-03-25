Feature: Sign up using email and password
  In order to log into the system
  As a user
  I want to register a new account

  Scenario: User signs up successfully with email
    Given I am on registration page
    When I submit registration form with required fields
    Then I should receive registration confirmation email
    When I go to confirmation page
    And I submit confirmation form with required fields
    Then I should be logged in from confirmation
