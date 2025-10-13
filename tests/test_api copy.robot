*** Settings ***
Resource   ../resources/keywords_api copy.robot     # /saucedemo_test1/resources/keywords_api.robot
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List
Library    JSONLibrary    # ใช้ To JSON แปลง content ให้เข้าถึงข้อมูลได้
Library    RequestsLibrary
Library    OperatingSystem     # for Get File



*** Test Cases ***
Run All API Test Cases
    # ${json_text}=    Get File    ${CURDIR}/../data/new_username.json    encoding=UTF-8
    ${data}=    Load Json From File    ${CURDIR}/../data/new_username.json    encoding=UTF-8
    FOR    ${item}    IN    @{data}
    ${tc}=    Get From Dictionary    ${item}    tc
    ${name}=    Get From Dictionary    ${item}    name
    ${job}=    Get From Dictionary    ${item}    job

    Log To Console    Running ${tc}
    Log To Console    Item: ${item}

    ${payload}=    Prepare Payload    ${name}    ${job}
    ${response}=    Send Create User Request    ${payload}
    Validate Response    ${tc}    ${response}    ${name}    ${job}
    END

    # FOR    ${item}    IN    @{data}

    #     ${payload}=    Prepare Payload    ${item['name']}    ${item['job']}
    #     ${response}=    Send Create User Request    ${payload}
    #     Validate Response    ${item['tc']}    ${response}    ${item['name']}    ${item['job']}
    # END


