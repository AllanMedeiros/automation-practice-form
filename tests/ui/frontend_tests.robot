*** Settings ***
Resource    ../../resources/demoqahome_page.resource
Resource    ../../resources/practice_form_page.resource
Resource    ../../resources/browser_windows_page.resource
Resource    ../../resources/web_tables_page.resource

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

Web Tables record test
    [Tags]    frontend    challenge_3
    Given the user access Demo QA page
    And navigate to Elements > Web Tables
    When the user creates a new record
    Then the record is properly displayed in the table
    When the user updates the new record
    Then the record is properly updated in the table
    When the user deletes the new record
    Then the record is not displayed in the table
    