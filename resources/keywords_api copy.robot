*** Settings ***
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List
Library    JSONLibrary    # ใช้ To JSON แปลง content ให้เข้าถึงข้อมูลได้
Library    RequestsLibrary


*** Variables ***
${BASE_URL}    https://reqres.in/api/users


*** Keywords ***
    # //test api
Create Long Text
    [Arguments]    ${char}    ${length}
    ${text}=    Evaluate    '${char}' * ${length}
    RETURN    ${text}

Prepare Payload
    [Arguments]    ${name}    ${job}
    &{payload}=    Create Dictionary    name=${name}    job=${job}
    RETURN    ${payload}

Send Create User Request
    [Arguments]    ${payload}
    Create Session    reqres    ${BASE_URL}
    ${response}=    POST On Session    reqres    /    json=${payload}
    RETURN    ${response}
    
Validate Response
    [Arguments]    ${tc}    ${response}    ${expected_name}    ${expected_job}
    ${status}=    Convert To String    ${response.status_code}
    ${json}=      To JSON    ${response.content}

    Run Keyword If    '${tc}' in ['TC01', 'TC02', 'TC03', 'TC04']
    ...    Should Be Equal As Strings    ${status}    201
    ...    Should Be Equal    ${json["name"]}    ${expected_name}
    ...    Should Be Equal    ${json["job"]}    ${expected_job}

    Run Keyword If    '${tc}' in ['TC05', 'TC06']
    ...    Log    ${tc}: API accepted empty field. This may indicate missing validation.    WARN
    ...    Should Be Equal As Strings    ${status}    201

    # Run Keyword If    '${tc}' in ['TC07','TC08']
    # ...    Log    ℹ${tc}: Boundary value test - Response status: ${status}    INFO
    # ${expected_status}=    Create List    201    400    422
    # ...    Should Contain Any    ${status}    @{expected_status}
    Run Keyword If    '${tc}' in ['TC07','TC08']    Should Contain Any    ${status}    201    400    422

    Run Keyword If    '${tc}' == 'TC09'
    ...    Log   ${tc}: Duplicate data test - Response status: ${status}    INFO
    ...    Should Contain Any    ${status}    "201"    "409"

    Run Keyword If    '${tc}' == 'TC10'
    ...    Log    ${tc}: Empty request was accepted. API may lack input validation.    WARN
    ...    Should Be Equal As Strings    ${status}    201

Should Contain Any
    [Arguments]    ${value}    @{expected}
    ${found}=    Evaluate    ${value} in ${expected}
    Run Keyword Unless    ${found}    Fail    '${value}' not in expected list: ${expected}
