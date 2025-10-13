*** Settings ***
Library    JSONLibrary
Library    Collections
Resource   ../resources/keywords_api copy 2.robot


*** Test Cases ***
POST_Create_User
    Disable Insecure Warning
    [Documentation]    ทดสอบ POST /users ด้วย test data จากไฟล์ JSON
    ${data}=    Load JSON From File    ../saucedemo_test1/data/post_user_data.json    encoding=UTF-8
    @{users}=   Get Value From Json    ${data}    $[*]
    FOR    ${user}    IN    @{users}
        ${tc}=      Get From Dictionary    ${user}    tc
        ${name}=    Get From Dictionary    ${user}    name
        ${job}=     Get From Dictionary    ${user}    job
        Log To Console    Running POST Test: ${tc} | ${name} / ${job}
        
        Create User    ${name}    ${job}    ${tc}
    END