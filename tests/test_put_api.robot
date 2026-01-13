*** Settings ***
Library    JSONLibrary
Library    Collections
Resource   ../resources/keywords_api.robot

*** Variables ***
${USER_ID}    2

*** Test Cases ***

TC1 Update User Valid ENG
    [Documentation]    Update user with valid English name and job
    ${name}=    Set Variable    panida test
    ${job}=     Set Variable    qa engineer
    ${response}=    Send Put User Request    ${USER_ID}    ${name}    ${job}
    Validate Put Response    ${response}    ${name}    ${job}

TC2 Update User Valid TH
    [Documentation]    Update user with valid Thai name and job
    ${name}=    Set Variable    พนิดา บานเย็น
    ${job}=     Set Variable    เจ้าหน้าที่ทดสอบระบบ
    ${response}=    Send Put User Request    ${USER_ID}    ${name}    ${job}
    Validate Put Response    ${response}    ${name}    ${job}

TC3 Update User Special Characters
    [Documentation]    Update user with special characters (ระบบยังคงตอบ 200)
    ${name}=    Set Variable    @#$%^^&*
    ${job}=     Set Variable    @@!!??
    ${response}=    Send Put User Request    ${USER_ID}    ${name}    ${job}
    Validate Put Response    ${response}    ${name}    ${job}

TC4 Update User Empty Value
    [Documentation]    Update user with empty name and job (ระบบยังคงตอบ 200)
    ${name}=    Set Variable    ${EMPTY}
    ${job}=     Set Variable    ${EMPTY}
    ${response}=    Send Put User Request    ${USER_ID}    ${name}    ${job}
    Validate Put Response    ${response}    ${name}    ${job}

TC5 Update User Long Character 250
    [Documentation]    Update user with 250 characters (ระบบยังคงตอบ 200)
    ${name}=    Generate Random String    250
    ${job}=     Generate Random String    250
    ${response}=    Send Put User Request    ${USER_ID}    ${name}    ${job}
    Validate Put Response    ${response}    ${name}    ${job}

TC6 Update Non Existing User
    [Documentation]    Update non-existing user (ระบบยังคงตอบ 200)
    ${name}=    Set Variable    kaori
    ${job}=     Set Variable    friend india
    ${response}=    Send Put User Request    9999    ${name}    ${job}
    Validate Put Response    ${response}    ${name}    ${job}



