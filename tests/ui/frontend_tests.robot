*** Settings ***
Resource    ../../resources/demoqahome_page.resource
Resource    ../../resources/practice_form_page.resource
Resource    ../../resources/browser_windows_page.resource
Resource    ../../resources/web_tables_page.resource
Resource    ../../resources/progress_bar_page.resource

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

Create 12 records in Web Table
    [Tags]    frontend    challenge_3    bonus_test
    [Setup]    Given the user access Demo QA page and navigates to Elements > Web Tables
    [Template]    Add multiple records in Web Table
    [Teardown]    Delete all created records
    # Record    Name        Last Name    Email                                Age    Salary        Department
    1           Tony        Stark        tony.stark@starkindustries.com       38     9999999999    Engineering
    2           Bruce       Banner       bruce.banner@usdod.com               39     500000        Military
    3           Steve       Rogers       steve.rogers@usarmy.com              26     350000        Army
    4           Thor        Odinson      thor.odinson@asgard.com              1500   9999999999    Confidential 
    5           Natasha     Romanov      natasha.romanov@kgb.com              37     150000        Special Operations
    6           Carol       Danvers      carol.danvers@usairforce.com         30     120000        Air Force
    7           Gamora      Whoberi      gamora.whoberi@milano.com            24     750000        Defense
    8           Clint       Barton       clint.barton@shield.com              00     250000        SHIELD
    9           James       Rhodes       james.rhodes@usairforce.com          40     700000        Air Force
    10          Sam         Wilson       sam.wilson@shield.com                00     50000         SHIELD    
    11          Pietro      Maximoff     pietro.maximoff@hidra.com            26     0             NDA
    12          Wanda       Maximoff     wanda.maximoff@hidra.com             28     0             NDA

Verify Progress Bar behavior
    [Tags]    frontend    challenge_4
    Given the user access Demo QA page
    And navigate to Widgets > Progress Bar
    And the user starts the Progress Bar
    When the Progress Bar is stoped before 25% mark
    Then the Progress Bar value must be lower or equal than 25%
    And the user resumes the Progress Bar until 100% and resets it
