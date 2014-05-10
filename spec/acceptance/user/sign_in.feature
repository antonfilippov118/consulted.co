Feature: Sign in
  In order to identify myself in the system
  As a registered user
  I want to sign in

  Background:
    Given I exist as user

  @javascript
  Scenario: User logs in successfully with email
    When I go to login page
    And I submit login form with valid credentials
    Then I should be logged in

  # If user previously signed up with linked in, user should be able to
  # restore his password if wants to login via emal
  Scenario: User forgets his password
    When I go to forgot password page
    And I request new password
    Then I should receive reset password instructions email
    When I go to restore password page
    And I submit restore password form with my new password
    Then I should be logged in from restore password page
