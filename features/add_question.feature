Feature: Add question
  In order to add question
  As a user
  I want to fill in the form

  Scenario: User with enougth points
    Given a signed in user "Lot points"
      And I'm on ask question page
    When I fill title "Some title" and contents "Some **md** content"
    Then see the "success" alert with "Question created"
      And answer with title "Some title" and contents "Some md content"

  Scenario: User with enougth points bun incorrect fill in form
    Given a signed in user "Lot points"
      And I'm on ask question page
    When I fill title "" and contents "Some **md** content"
    Then see the "danger" alert with "Please review the problems below:"

  Scenario: User with NOT enougth points
    Given a signed in user "Few points"
      And I'm on ask question page
    Then see the "warning" alert with "You don't have enough points to ask the question"
