*** Settings ***
Library    JSONLibrary
Library    Collections
Resource   ../resources/keywords_api.robot

*** Variables ***
${USER_ID}    2

*** Test Cases ***
TC1 Delete User Existing
    [Documentation]    Delete a user by ID in case existing user
    ${response}=    Send Delete User Request    2
    Validate Delete Response 204    ${response}

TC2 Delete User Non Existing
    [Documentation]    Delete a user by ID in case non-existing user
    ${response}=    Send Delete User Request    9999
    Validate Delete Response 204    ${response}



