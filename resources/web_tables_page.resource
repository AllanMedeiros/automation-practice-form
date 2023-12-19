*** Settings ***
Resource        browser.resource
Resource        demoqahome_page.resource
Variables       web_tables_page.yaml

*** Variables ***
${FIRST_NAME}    Tony 
${LAST_NAME}     Stark 
${EMAIL}         tony.stark@starkindustries.com 
${AGE}           38
${NEW_AGE}       53
${SALARY}        9999999999 
${DEPTO}         Engineering 


*** Keywords ***
the user creates a new record
    ${RECORD_QTY}   Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${RECORD_QTY}
    Click Button    ${web_tables_page.add_record_btn}
    Fill New Record Form and Submit

Fill New Record Form and Submit
    [Arguments]    ${record}=${NONE}    ${name}=${FIRST_NAME}    ${last_name}=${LAST_NAME}    ${email_address}=${EMAIL}    ${user_age}=${AGE}    ${salary_value}=${SALARY}    ${department}=${DEPTO}
    Input Text    ${web_tables_page.first_name_txt}        ${name}
    Input Text    ${web_tables_page.last_name_txt}         ${last_name} 
    Input Text    ${web_tables_page.user_email_email}      ${email_address}
    Input Text    ${web_tables_page.age_nmb}               ${user_age}       
    Input Text    ${web_tables_page.salary_cur}            ${salary_value}    
    Input Text    ${web_tables_page.department_txt}        ${department}     
    Click Button    ${web_tables_page.submit_btn}


Update rows per page if needed
    ${current_rows_selected}     Get Selected List Value    ${web_tables_page.rows_per_page_sel}
    ${rows_per_page_values}      Get List Items    ${web_tables_page.rows_per_page_sel}    values=${True}
    ${current_rows_sel_index}    Get Index From List    ${rows_per_page_values}    ${current_rows_selected}
    IF    ${CURRENT_RECORD_QTY} >= ${current_rows_selected}
        ${next_rows_sel_value}    Get From List    ${rows_per_page_values}    ${current_rows_sel_index+1}
        Select From List By Value    ${web_tables_page.rows_per_page_sel}    ${next_rows_sel_value}
    END

the record is properly displayed in the table
    [Arguments]    ${name}=${FIRST_NAME}
    # Sleep    0.5 s    reason=Wait the record list to be updated with the new record.
    ${CURRENT_RECORD_QTY}    Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${CURRENT_RECORD_QTY}
    Update rows per page if needed
    Should Be True    ${CURRENT_RECORD_QTY} > ${RECORD_QTY}    msg=New record was not found in the table
    Element Should Contain    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY})    ${name}    message=New record was not found in the table

the user updates the new record
    ${edit_record_btn}    Set Variable    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY}) span:nth-child(1) svg
    Click Element    ${edit_record_btn}
    Input Text    ${web_tables_page.age_nmb}    ${NEW_AGE}
    Click Button    ${web_tables_page.submit_btn}

the record is properly updated in the table
    ${age_cell}    Set Variable    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY}) div.rt-td:nth-child(3)
    Element Text Should Be    ${age_cell}    ${NEW_AGE}    message=Record was not updated as expected

the user deletes the new record
    [Arguments]    ${record}=${CURRENT_RECORD_QTY}
    ${delete_record_btn}    Set Variable    ${web_tables_page.all_record_rows_htm}:nth-child(${record}) span:nth-child(2) svg
    Click Element    ${delete_record_btn}
    ${UPDATED_RECORD_QTY}    Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${UPDATED_RECORD_QTY}

the record is not displayed in the table
    Should Be True    ${UPDATED_RECORD_QTY} == ${CURRENT_RECORD_QTY-1}    msg=Record was not deleted from the table

the user access Demo QA page and navigates to Elements > Web Tables
    the user access Demo QA page
    navigate to Elements > Web Tables
    Get initial record count

the user adds a new record
    ${RECORD_QTY}   Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${RECORD_QTY}
    Click Button    ${web_tables_page.add_record_btn}

Get initial record count
    ${INITIAL_RECORD_QTY}   Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${INITIAL_RECORD_QTY}

Add multiple records in Web Table
    [Arguments]    ${record}    ${name}    ${last_name}    ${email}    ${age}    ${salary}    ${department}
    the user adds a new record
    Fill New Record Form and Submit    ${record}    ${name}    ${last_name}    ${email}    ${age}    ${salary}    ${department}
    the record is properly displayed in the table    ${name}

Delete all created records    
    Log    ${INITIAL_RECORD_QTY}
    WHILE    ${CURRENT_RECORD_QTY} > ${INITIAL_RECORD_QTY}
        the user deletes the new record    ${CURRENT_RECORD_QTY}
        ${CURRENT_RECORD_QTY}    Evaluate    ${CURRENT_RECORD_QTY} -1
    END
