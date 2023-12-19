*** Settings ***
Resource        browser.resource
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
    Fill New Record Form

Fill New Record Form
    Input Text    ${web_tables_page.first_name_txt}        ${FIRST_NAME}
    Input Text    ${web_tables_page.last_name_txt}         ${LAST_NAME} 
    Input Text    ${web_tables_page.user_email_email}      ${EMAIL}     
    Input Text    ${web_tables_page.age_nmb}               ${AGE}       
    Input Text    ${web_tables_page.salary_cur}            ${SALARY}    
    Input Text    ${web_tables_page.department_txt}        ${DEPTO}     
    Click Button    ${web_tables_page.submit_btn}


the record is properly displayed in the table
    ${CURRENT_RECORD_QTY}    Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${CURRENT_RECORD_QTY}
    Should Be True    ${CURRENT_RECORD_QTY} > ${RECORD_QTY}    msg=New record was not found in the table
    Element Should Contain    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY})    ${FIRST_NAME}    message=New record was not found in the table

the user updates the new record
    ${edit_record_btn}    Set Variable    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY}) span:nth-child(1) svg
    Click Element    ${edit_record_btn}
    Input Text    ${web_tables_page.age_nmb}    ${NEW_AGE}
    Click Button    ${web_tables_page.submit_btn}

the record is properly updated in the table
    ${age_cell}    Set Variable    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY}) div.rt-td:nth-child(3)
    Element Text Should Be    ${age_cell}    ${NEW_AGE}    message=Record was not updated as expected

the user deletes the new record
    ${delete_record_btn}    Set Variable    ${web_tables_page.all_record_rows_htm}:nth-child(${CURRENT_RECORD_QTY}) span:nth-child(2) svg
    Click Element    ${delete_record_btn}
    ${UPDATED_RECORD_QTY}    Get Element Count    ${web_tables_page.all_action_buttons_icn}
    Set Global Variable    ${UPDATED_RECORD_QTY}

the record is not displayed in the table
    Should Be True    ${UPDATED_RECORD_QTY} == ${CURRENT_RECORD_QTY-1}    msg=Record was not deleted from the table

