@allow-rescue
Scenario: 404 page
  When I go to the path "/foobar123123123"
  Then the page should be titled "Consulted - Not found"
    And I should see "We thought we were directionally correct, but than this happened..."
    And the response status should be "404"