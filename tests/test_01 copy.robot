*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***
${URL}    https://www.saucedemo.com/
${USERNAME}    standard_user
${PASSWORD}    secret_sauce
${PRODUCT_ID}    product_id

*** Test Cases ***
Login With One User to oder product
    [Tags]    login function
    [Documentation]    ทดสอบ login ด้วย standard_user แบบไม่ใช้ลูป
    Open Browser    ${URL}    chrome
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}    
    Click Button  id=login-button
    Sleep    2s
    # ถ้า login สำเร็จจะเข้าสู่หน้า product
    # สามารถเพิ่มคำสั่งตรวจสอบได้ เช่น Page Should Contain Element
    Close Browser
