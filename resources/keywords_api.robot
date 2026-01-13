*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    BuiltIn
Library    String
Library    Process




*** Variables ***
${BASE_URL}    https://reqres.in/api
${API_KEY_NAME}    x-api-key
${API_KEY}    reqres_2787fd94d3df4bb0adc6fd836a0e7a2b    #reqres-free-v1

*** Keywords ***
# เพิ่มสำหรับ POST /users
Create API Headers
    ${headers}=    Create Dictionary    ${API_KEY_NAME}=${API_KEY}    Content-Type=application/json
    RETURN    ${headers}
    
Disable Insecure Warning
    ${urllib3}=    Evaluate    __import__('urllib3')
    Call Method    ${urllib3}    disable_warnings    ${urllib3.exceptions.InsecureRequestWarning}
    
Send Create User Request
    [Arguments]    ${name}    ${job}
    ${headers}=    Create API Headers
    ${data}=    Create Dictionary    name=${name}    job=${job}

    Create Session    api    ${BASE_URL}
    ${response}=    POST On Session    api    /users    json=${data}    headers=${headers}
    Log To Console    \nResponse: ${response.json()}
    RETURN    ${response}

Validate Get Response
    [Arguments]    ${tc}    ${response}    ${expected_name}    ${expected_job}    ${expected_status}=201
    
    ${expected_status}=    Convert To Integer    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ${resp_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${resp_json['name']}    ${expected_name}
    Should Be Equal    ${resp_json['job']}     ${expected_job}

# เพิ่มสำหรับ GET /users/{id}
Get User By Id
    [Arguments]    ${user_id}=${EMPTY}
    ${headers}=    Create API Headers
    Create Session    api    ${BASE_URL}
    
    # ถ้า id ว่าง ให้เรียก /users
    IF    '${user_id}' == '' or '${user_id}' == '""'
        ${url}=    Set Variable    /users
    ELSE
        ${url}=    Set Variable    /users/${user_id}
    END

    ${response}=    GET On Session    api    ${url}    headers=${headers}    expected_status=any
    Log To Console    \nGET URL: ${url}
    Log To Console    \nGET Response: ${response.text}
    RETURN    ${response}


Validate Get User Response     # กรณีระบุ id
    [Arguments]    ${response}    ${expected_id}    ${expected_status}=200
    ${expected_status}=    Convert To Integer    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

    # แปลง body เป็น JSON แล้วดึง data
    ${body}=    Set Variable    ${response.json()}
    ${user}=    Get From Dictionary    ${body}    data

    # ตรวจสอบว่ามี field ครบตาม requirement
    Dictionary Should Contain Key    ${user}    id
    Dictionary Should Contain Key    ${user}    email
    Dictionary Should Contain Key    ${user}    first_name
    Dictionary Should Contain Key    ${user}    last_name
    Dictionary Should Contain Key    ${user}    avatar

    # ตรวจสอบว่า id ตรงกับที่คาดไว้ (เช่น 2)
    ${actual_id}=    Get From Dictionary    ${user}    id
    Should Be Equal As Integers    ${actual_id}    ${expected_id}

Validate Get Users Response    # กรณีเรียก GET /users โดยไม่ระบุ id
    [Arguments]    ${response}    ${expected_status}=200
    ${expected_status}=    Convert To Integer    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

    ${body}=    Set Variable    ${response.json()}
    ${users}=    Get From Dictionary    ${body}    data

    # ตรวจว่ามี user อย่างน้อย 1 ราย
    ${count}=    Get Length    ${users}
    Should Be True    ${count} > 0    msg=Expected at least 1 user in list

    # เช็ค field ของ user ตัวแรก
    ${first_user}=    Get From List    ${users}    0
    Dictionary Should Contain Key    ${first_user}    id
    Dictionary Should Contain Key    ${first_user}    email
    Dictionary Should Contain Key    ${first_user}    first_name
    Dictionary Should Contain Key    ${first_user}    last_name
    Dictionary Should Contain Key    ${first_user}    avatar

Validate Get User Not Found
    [Arguments]    ${response}    ${expected_status}=404    #ค่า default เป็น 404
    ${expected_status}=    Convert To Integer    ${expected_status}

    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

    # สำหรับ 404 ของ reqres.in body จะว่าง {} หรือ text "{}"
    Log To Console    User not found as expected (404)

Validate Response Time
    [Arguments]    ${start_time}    ${end_time}    ${max_seconds}=2
    ${elapsed}=    Evaluate    ${end_time} - ${start_time}
    Log To Console    \nResponse Time: ${elapsed} seconds
    Should Be True    ${elapsed} < ${max_seconds}    msg=Response time exceeded SLA

# เพิ่มสำหรับ PUT /users/{id}
Send Put User Request
    [Arguments]    ${user_id}    ${name}    ${job}
    ${headers}=    Create API Headers
    Disable Insecure Warning
    Create Session    api    ${BASE_URL}

    ${data}=    Create Dictionary    name=${name}    job=${job}

    ${response}=    PUT On Session    api    /users/${user_id}    json=${data}    headers=${headers}    expected_status=any

    Log To Console    \nPUT URL: /users/${user_id}
    Log To Console    PUT Payload: ${data}
    Log To Console    PUT Response: ${response.text}

    RETURN    ${response}

Validate Put Response
    [Arguments]    ${response}    ${expected_name}    ${expected_job}

    # ตรวจว่า status ต้องเป็น 200
    Should Be Equal As Integers    ${response.status_code}    200

    # แปลง response body เป็น JSON
    ${body}=    Set Variable    ${response.json()}

    # ตรวจว่ามี field updatedAt
    Dictionary Should Contain Key    ${body}    updatedAt

    # ตรวจว่า name ถูกต้อง
    Should Be Equal    ${body['name']}    ${expected_name}

    # ตรวจว่า job ถูกต้อง
    Should Be Equal    ${body['job']}     ${expected_job}

    Log To Console    \nPUT Response Validated Successfully

# เพิ่มสำหรับ DELETE /users/{id}
Send Delete User Request
    [Arguments]    ${user_id}
    ${headers}=    Create API Headers
    Disable Insecure Warning
    Create Session    api    ${BASE_URL}

    ${response}=    DELETE On Session    api    /users/${user_id}    headers=${headers}    expected_status=any

    Log To Console    \nDELETE URL: /users/${user_id}
    Log To Console    DELETE Response Status: ${response.status_code}
    RETURN    ${response}

Validate Delete Response 204
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    204
    Log To Console    \nDELETE Response validated: 204 No Content
