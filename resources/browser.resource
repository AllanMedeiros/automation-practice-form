*** Settings ***
Library             SeleniumLibrary    timeout=${SELENIUM_TIMEOUT}    run_on_failure=Wait before fail and take screenshot
Library             OperatingSystem
Library             Collections
Library             String
Library             FakerLibrary
Library             DateTime

*** Variables ***
# Also declaring global variables here to avoid RF Language Server extension think they are not defined (they are set in robot_variables.py)
${SELENIUM_SERVER}
${SELENIUM_PORT}
${SELENIUM_TIMEOUT}
${BROWSER}

*** Keywords ***
Initial setup
    # ${browser_options}    Setup Browser Options
    # This test suite was only tested in Chrome for the moment (hardcoded Chrome Options)
    # ${PROFILE_PATH}    Set Variable    C:\\Users\\allan\\AppData\\Local\\Temp
    ${EXC_SWITCHES}    Create List    enable-automation    enable-logging

    # Setting this SPKI encoded list using list variable is not working, so they are hardcoded in options paramenter
    ${IGNORE_CERT_SHA_LIST}    Create List    y3Ji93o4mfDFW5Sctsm4SXJoj7YuE9KJ+eI38btmffQ=    rgg1koKh91gNxf0QTygpd9qlFmRMwnxyN0z1ZXaHadU=    OAzuMECzRKx2czgvDAKashJs3dc4pJKQfWtdYrXu8gk=

    IF    "${BROWSER}" in ("chrome", "googlechrome", "gc", "headlesschrome")
        IF    $SELENIUM_SERVER==""
            Open Browser      url=about:blank    browser=${BROWSER}
            ...               options=set_capability("acceptInsecureCerts",${TRUE});add_extension(r"${CURDIR}${/}AdBlock.crx");add_argument(r"--user-data-dir=${PROFILE_PATH}");add_experimental_option("excludeSwitches",${EXC_SWITCHES});add_argument("--start-maximized");add_argument("--disable-web-security");add_argument("--ignore-certificate-errors-spki-list=y3Ji93o4mfDFW5Sctsm4SXJoj7YuE9KJ+eI38btmffQ=,rgg1koKh91gNxf0QTygpd9qlFmRMwnxyN0z1ZXaHadU=,OAzuMECzRKx2czgvDAKashJs3dc4pJKQfWtdYrXu8gk=")
        ELSE
            Open Browser      url=about:blank    browser=${BROWSER}
            ...               remote_url=http://${SELENIUM_SERVER}:${SELENIUM_PORT}/wd/hub
            ...               options=set_capability("acceptInsecureCerts",${TRUE});add_experimental_option("excludeSwitches",${EXC_SWITCHES});add_argument("--start-maximized");add_argument("--disable-web-security");add_argument("--ignore-certificate-errors-spki-list=y3Ji93o4mfDFW5Sctsm4SXJoj7YuE9KJ+eI38btmffQ=,rgg1koKh91gNxf0QTygpd9qlFmRMwnxyN0z1ZXaHadU=,OAzuMECzRKx2czgvDAKashJs3dc4pJKQfWtdYrXu8gk=")            
        END
    ELSE
        Fatal Error    Browser ${BROWSER} is not supported, check your variables file!
    END

Setup Browser Options
  # TODO: Set browser options for each supported browser
  No Operation

Wait before fail and take screenshot
    Sleep  5 s
    Capture Page Screenshot