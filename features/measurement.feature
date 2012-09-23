Feature: Users can get a measurement result

  Scenario: User performs measurements
    When I provide some measurement data
    Then I should get a measurement result
