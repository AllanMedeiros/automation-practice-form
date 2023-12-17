*** Settings ***
Resource        browser.resource
Variables       demoqahome_page.yaml
Library    ../env/lib/site-packages/robot/libraries/Dialogs.py

*** Variables ***
${URL}    https://demoqa.com/
# ${URL}    https://google.com/

*** Keywords ***
the user access Demo QA page
    Go To    ${URL}
navigate to Forms > Practice Form
    Click Element    ${homepage.forms_mn}
    Element Should Contain    ${homepage.page_title_htm}    Forms            message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})
    Click Element    ${formspage.practice_form_mn}
    Element Should Contain    ${homepage.page_title_htm}    Practice Form    message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})
    Sleep    5 s

