*** Settings ***
Resource        browser.resource
Variables       practice_form_page.yaml

*** Keywords ***
fill all the fields with random values
    ${first_name}    First Name
    Input Text    ${practice_form_page.first_name_txt}    ${first_name}
    ${last_name}     Last Name
    Input Text    ${practice_form_page.last_name_txt}    ${last_name}
    ${email}         Email
    Input Text    ${practice_form_page.user_email_email}    ${email}
    ${gender_rdi}    Random Element    elements='gender_male_rdi', 'gender_female_rdi', 'gender_other_rdi'    
    Click Element    ${practice_form_page.${gender_rdi}}
    ${mobile_number}    Random Number    digits=10    fix_len=${True}
    Input Text    ${practice_form_page.mobile_number_nmb}    ${mobile_number}
    Fill Birth Date and bypass datepicker
    Add subjects    3
    Choose Random Hobbies
    Choose File    ${practice_form_page.select_picture_file_btn}    ${CURDIR}${/}upload.txt
    ${address}    Address
    Input Text    ${practice_form_page.current_address_rstxt}    ${address}
    Select State
    Select City

Select State
    Click Element    ${practice_form_page.state_sel}
    Wait Until Element Is Visible    ${practice_form_page.all_state_item_opt}    timeout=0.5 s
    ${states_qty}    Get Element Count    ${practice_form_page.all_state_item_opt}
    ${random_state_item}    Random Int    min=0    max=${states_qty-1}
    Click Element    ${practice_form_page.state_item_opt}${random_state_item}

Select City
    Click Element    ${practice_form_page.city_sel}
    Wait Until Element Is Visible    ${practice_form_page.all_city_item_opt}    timeout=0.5 s
    ${cities_qty}    Get Element Count    ${practice_form_page.all_city_item_opt}
    ${random_city_item}    Random Int    min=0    max=${cities_qty-1}
    Click Element    ${practice_form_page.city_item_opt}${random_city_item}

Choose Random Hobbies    
    ${is_sports}    Boolean
    IF    ${is_sports}    Click Element    ${practice_form_page.hobby_sports_chk}        
    ${is_reading}    Boolean
    IF    ${is_reading}    Click Element    ${practice_form_page.hobby_reading_chk}
    ${is_music}    Boolean
    IF    ${is_music}    Click Element    ${practice_form_page.hobby_music_chk}

Fill Birth Date and bypass datepicker
    ${birth_date}    Date Of Birth    minimum_age=14
    ${birth_date_str}    Convert To String    ${birth_date}
    ${birth_date_formated}    Convert Date    ${birth_date_str}    result_format=%d %b %Y
    Click Element    ${practice_form_page.birth_date_date}
    Press Keys    ${practice_form_page.birth_date_date}    CONTROL+A    SPACE
    Sleep  1 s    reason=Sleep to avoid issues on filling Birth Date
    Input Text    ${practice_form_page.birth_date_date}    ${birth_date_formated}
    Press Keys    ${practice_form_page.birth_date_date}    ESC

Add subjects
    [Documentation]    Add a custom quantity of subjects into subjects field. Each subject is randomly selected.
    [Arguments]    ${subjects_qty}    

    WHILE    ${subjects_qty} > ${0}
        ${found_subject}    Set Variable    ${FALSE}
        WHILE    ${found_subject} == ${FALSE}
            ${random_letter}     Random Lowercase Letter
            Input Text    ${practice_form_page.subjects_lkp}    ${random_letter}
            ${found_subject}    Run Keyword And Return Status
                ...  Wait Until Element Is Visible    ${practice_form_page.subject_list_sel}    timeout=0.1 s
            IF    ${found_subject} == ${FALSE}
                Press Keys    ${practice_form_page.subjects_lkp}    BACKSPACE
            END
        END
        ${subjects_list_qty}    Get Element Count    ${practice_form_page.all_subject_list_itens_opt}
        IF    ${subjects_list_qty} == ${0}
            Fail    No subject itens available to be selected! Or possible timing issue.
        END
        ${random_subject_item}    Random Int    min=1    max=${subjects_list_qty}
        Click Element    ${practice_form_page.all_subject_list_itens_opt}:nth-child(${random_subject_item}) 
        ${subjects_qty}    Evaluate    ${subjects_qty} -1
    END

the form is submited
    Click Element    ${practice_form_page.submit_btn}

the confirmation popup is displayed
    Wait Until Element Contains    ${practice_form_page.popup_title_htm}    Thanks for submitting the form    timeout=5 s    error=Confirmation popup was not displayed
