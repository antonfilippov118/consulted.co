Feature: Sign in
  In order to protect my identity
  As a signed in admin
  I want to sign out

  Scenario: Admin signs out
    Given I am signed in as admin
    When I sign out as admin
    Then I should be on home page
