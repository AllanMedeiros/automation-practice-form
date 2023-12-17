*** Settings ***
Resource    ../../resources/demoqahome_page.resource
Resource    ../../resources/practice_form_page.resource

*** Test Cases ***

Fill Form with random values
    [Tags]    frontend    challenge_1
    Given the user access Demo QA page
    And navigate to Forms > Practice Form
    And fill all the fields with random values
    When the form is submited
    Then the confirmation popup is displayed