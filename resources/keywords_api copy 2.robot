*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    BuiltIn
Library    String
Library    Process
Library    Collections

*** Variables ***
${BASE_URL}    https://reqres.in/api
${API_KEY_NAME}    x-api-key
${API_KEY}    reqres-free-v1

*** Keywords ***
Disable Insecure Warning
    ${urllib3}=    Evaluate    __import__('urllib3')
    Call Method    ${urllib3}    disable_warnings    ${urllib3.exceptions.InsecureRequestWarning}
    
Create User
    [Arguments]    ${name}    ${job}    ${tc}=${EMPTY}
    ${headers}=    Create Dictionary    ${API_KEY_NAME}=${API_KEY}    Content-Type=application/json
    ${data}=    Create Dictionary    name=${name}    job=${job}

    # --- Check empty input ---
    Run Keyword If    '${name}' == '' or '${job}' == ''    Handle Empty Input    ${data}    ${tc}

    Create Session    api    ${BASE_URL}
    ${response}=    POST On Session    api    /users    json=${data}    headers=${headers}
    Log To Console    \nResponse: ${response.json()}

    Should Be Equal As Integers    ${response.status_code}    201
    ${resp_json}=    Set Variable    ${response.json()} 
    Should Be Equal    ${resp_json['name']}    ${name}
    Should Be Equal    ${resp_json['job']}    ${job}

Handle Empty Input
    [Arguments]    ${data}    ${tc}=${EMPTY}
    Log    ${tc}: Empty request was accepted. API may lack input validation.    WARN
    # ไม่ต้องส่ง request เพิ่ม

    # Disable SSL Warnings
#     [Documentation]    Disables InsecureRequestWarning from urllib3.
#     Evaluate    import urllib3; urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)    modules=urllib3