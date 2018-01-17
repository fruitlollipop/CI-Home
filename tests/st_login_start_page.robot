*** Settings ***
Documentation   ST login to start page
Default Tags    ST  Login

Library     SeleniumLibrary

*** Test Cases ***
Test title
    [Tags]    Test
    Open Browser    http://192.168.0.119:8083   ${browser}
    Page Should Contain     Congratulations on your first Django-powered page
    [teardown]      Close Browser