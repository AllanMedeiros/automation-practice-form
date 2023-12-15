*** Settings ***
Resource        ../../resource/demoqahome.resource
Resource        ../../practice_form.resource

*** Test Cases ***

Fill Form with random values
    Given the user access Demo QA page
    And navigate to Forms > Practice Form
    And fill all the fields with random values
    When the form is submited
    Then the confirmation popup is displayed