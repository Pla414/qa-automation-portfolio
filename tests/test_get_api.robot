*** Settings ***
Library    JSONLibrary
Library    Collections
Resource   ../resources/keywords_api.robot

*** Test Cases ***
TC1 GET User with valid ID
    [Documentation]    TC1: ส่ง GET /users/2 แล้วต้องได้ 200 และมีข้อมูล user ครบทุก field
    ${response}=    Get User By Id    2
    Validate Get User Response    ${response}    2    200

TC2 GET User Without ID
    [Documentation]    TC2: เรียก GET /users โดยไม่ใส่ id ต้องได้ 200 และข้อมูล user ต้องมี id, email, first_name, last_name, avatar
    ${response}=    Get User By Id    ""
    Validate Get Users Response    ${response}    200

TC3 GET User With Character
    [Documentation]    TC3: ส่ง GET /users/abc ต้องได้ Status 404 Not Found
    ${response}=    Get User By Id    abc
    Validate Get User Not Found    ${response}    404

TC4 GET User With Special Character
    [Documentation]    TC4: ส่ง GET /users/#@qa (encode เป็น %23%40qa) ต้องได้ Status 404 Not Found
    ${response}=    Get User By Id    %23%40qa
    Validate Get User Not Found    ${response}    404

TC5 GET User ID Non exist
    [Documentation]    TC5: ส่ง GET /users/9999 (id ที่ไม่มีในระบบ) ต้องได้ Status 404 Not Found
    ${response}=    Get User By Id    9999
    Validate Get User Not Found    ${response}    404

TC6 GET User ResponseTime
    [Documentation]    TC6: ทดสอบ response time ต้องน้อยกว่า 2 วินาที
    ${start}=    Get Time    epoch
    ${response}=    Get User By Id    2   # ใช้ user id จริง
    ${end}=    Get Time    epoch
    Validate Response Time    ${start}    ${end}    2



