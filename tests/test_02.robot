*** Settings ***
Library    SeleniumLibrary            
Library    JSONLibrary
Library    Collections

*** Variables ***
${URL}    https://www.saucedemo.com/

*** Test Cases ***
Login With All Users
    [Documentation]    #ทดสอบ login ด้วย user ทุกตัวจากไฟล์ JSON
    [Tags]    Login function
    Open Browser    ${URL}    chrome
    ${data}=    Load JSON From File    ../saucedemo_test1/data/login_data.json
    
    @{users}=    Get Value From Json    ${data}       $.users[*]
    FOR    ${users}    IN    @{users}
        ${username}=    Get From Dictionary    ${users}    username
        ${password}=    Get From Dictionary    ${users}    password

        Log To Console    Trying to login with: ${password}
        Input Text    id=user-name    ${username}
        Input Text    id=password     ${password}
        Click Button   id=login-button
        Sleep          1s

        #Capture screenshot แล้วตั้งชื่อไฟล์ตาม username
        Capture Page Screenshot    filename=${CURDIR}/screenshots/${username}.jpg 


        Run Keyword And Ignore Error    Click Button    id=react-burger-menu-btn
        Run Keyword And Ignore Error    Click Link      Logout
        Go To         ${URL}
    END
    Close Browser
