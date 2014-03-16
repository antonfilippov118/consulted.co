Feature: Sign in
  In order to identify myself in the system
  As a registered admin
  I want to sign in

  Background:
    Given I exist as admin

  Scenario: Admin signs in successfully
    When I sign in as admin with valid credentials
    Then I should be on admin page

  Scenario: Admin signs in with invalid credentials
    When I sign in as admin with invalid credentials
    Then I should be on admin sign in page
