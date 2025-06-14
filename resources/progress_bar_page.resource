*** Settings ***
Resource     browser.resource
Variables    progress_bar_page.yaml

*** Keywords ***
the user starts the Progress Bar
    Click Button    ${progress_bar_page.start_stop_btn}

the Progress Bar is stopped before 25% mark
    ${loop_value}    Set Variable    ${0}
    ${stop_value}    Random Int    min=1    max=24
    WHILE    ${loop_value} <= ${stop_value}
        ${current_progress_bar_value}    Get Element Attribute    ${progress_bar_page.progress_bar_htm}    aria-valuenow
        ${loop_value}    Convert To Integer    ${current_progress_bar_value}
    END
    Click Button    ${progress_bar_page.start_stop_btn}
    Sleep    2 s    reason=Minor sleep to avoid validation issues

the Progress Bar value must be lower or equal than 25%
    ${current_progress_bar_value}    Get Element Attribute    ${progress_bar_page.progress_bar_htm}    aria-valuenow
    ${current_progress_bar_value}    Convert To Integer    ${current_progress_bar_value}
    Should Be True    ${current_progress_bar_value} <= ${25}

the user resumes the Progress Bar until 100% and resets it
    Click Button    ${progress_bar_page.start_stop_btn}
    ${loop_value}    Set Variable    ${0}
    WHILE    ${loop_value} < ${100}
        ${current_progress_bar_value}    Get Element Attribute    ${progress_bar_page.progress_bar_htm}    aria-valuenow
        ${loop_value}    Convert To Integer    ${current_progress_bar_value}
    END
    Click Button    ${progress_bar_page.reset_btn}
