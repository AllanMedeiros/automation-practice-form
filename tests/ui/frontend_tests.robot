*** Settings ***
Resource    ../../resources/demoqahome_page.resource
Resource    ../../resources/practice_form_page.resource
Resource    ../../resources/browser_windows_page.resource

*** Test Cases ***
Fill Form with random values
    [Tags]    frontend    challenge_1
    Given the user access Demo QA page
    And navigate to Forms > Practice Form
    And fill all the fields with random values
    When the form is submited
    Then the confirmation popup is displayed

New Window behavior test
    [Tags]    frontend    challenge_2
    Given the user access Demo QA page
    And navigate to Alerts, Frame & Windows > Browser Windows
    When the user clicks on New Window button
    Then a new Window is displayed with expected text
    And the user closes the window