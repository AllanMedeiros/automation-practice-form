*** Settings ***
Resource        browser.resource
Variables       demoqahome_page.yaml

*** Variables ***
${URL}    https://demoqa.com/
# ${URL}    https://google.com/

*** Keywords ***
the user access Demo QA page
    Go To    ${URL}
navigate to Forms > Practice Form
    Click Element    ${mainmenu.forms_mn}
    Element Should Contain    ${mainmenu.page_title_htm}    Forms            message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})
    Click Element    ${formsmenu.practice_form_mn}
    Element Should Contain    ${mainmenu.page_title_htm}    Practice Form    message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})

navigate to Alerts, Frame & Windows > Browser Windows
    Click Element    ${mainmenu.alerts_frame_windows_mn}
    Element Should Contain    ${mainmenu.page_title_htm}    Alerts, Frame & Windows    message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})
    Click Element    ${alertsmenu.browser_windows_mn}
    Element Should Contain    ${mainmenu.page_title_htm}    Browser Windows            message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})

navigate to Elements > Web Tables
    Click Element    ${mainmenu.elements_mn}
    Element Should Contain    ${mainmenu.page_title_htm}    Elements            message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})
    Click Element    ${elementsmenu.web_tables_mn}
    Element Should Contain    ${mainmenu.page_title_htm}    Web Tables            message=Expected page is not displayed within the default timeout (${SELENIUM_TIMEOUT})