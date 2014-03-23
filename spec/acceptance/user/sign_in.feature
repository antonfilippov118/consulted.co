Feature: Sign in
  In order to identify myself in the system
  As a registered user
  I want to sign in

  Scenario: User logs in successfully with email
    Given I exist as user
    When I go to login page
    And I submit login form with valid credentials
    Then I should be logged in

  # Scenario: User signs in with invalid credentials
  #   Given I exist as a user
  #   When I sign in with invalid credentials
  #   Then I should be signed out

  # Scenario: User has not confirmed email address
  #   Given I exist as a user with not confirmed email
  #   When I sign in with valid credentials
  #   Then I should see that my email is not confirmed

  # Scenario: User forgets his password
  #   Given I exist as a user
  #   When I request new password
  #   Then I should receive reset password instructions email
