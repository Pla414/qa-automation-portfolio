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
Create API Headers
    ${headers}=    Create Dictionary    ${API_KEY_NAME}=${API_KEY}    Content-Type=application/json
    [Return]    ${headers}
    
Disable Insecure Warning
    ${urllib3}=    Evaluate    __import__('urllib3')
    Call Method    ${urllib3}    disable_warnings    ${urllib3.exceptions.InsecureRequestWarning}
    
Send Create User Request
    [Arguments]    ${name}    ${job}
    ${headers}=    Create Dictionary    ${API_KEY_NAME}=${API_KEY}    Content-Type=application/json
    ${data}=    Create Dictionary    name=${name}    job=${job}

    Create Session    api    ${BASE_URL}
    ${response}=    POST On Session    api    /users    json=${data}    headers=${headers}
    Log To Console    \nResponse: ${response.json()}
    RETURN    ${response}

Validate Response
    [Arguments]    ${tc}    ${response}    ${expected_name}    ${expected_job}    ${expected_status}=201
    
    ${expected_status}=    Convert To Integer    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ${resp_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${resp_json['name']}    ${expected_name}
    Should Be Equal    ${resp_json['job']}     ${expected_job}
