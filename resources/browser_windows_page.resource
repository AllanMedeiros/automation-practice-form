*** Settings ***
Resource        browser.resource
Variables       browser_windows_page.yaml

*** Keywords ***
the user clicks on New Window button
    Click Button    ${browser_windows_page.new_window_btn}

a new Window is displayed with expected text
    Switch Window    NEW
    Element Should Contain    ${browser_windows_page.new_window_text_htm}    This is a sample page

the user closes the window
    Close Window
    Switch Window    MAIN