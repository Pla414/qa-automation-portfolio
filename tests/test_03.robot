*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://www.saucedemo.com/

*** Test Cases ***
Test Login Valid User
    [Documentation]    ทดสอบการเข้าสู่ระบบด้วยข้อมูลที่ถูกต้อง
    Open Browser    ${URL}    chrome
    Input Text    id=user-name    standard_user
    Input Text    id=password    secret_sauce
    Click Button    id=login-button
    Sleep    2s
    Close Browser

Test Login Invalid User
    [Documentation]    ทดสอบการเข้าสู่ระบบด้วยข้อมูลที่ไม่ถูกต้อง
    Open Browser    ${URL}    chrome
    Input Text    id=user-name    invalid_user
    Input Text    id=password    wrong_password
    Click Button    id=login-button
    Sleep    2s
    Close Browser

Test Order Valid Product
    [Documentation]    ทดสอบการสั่งซื้อสินค้าที่มีอยู่
    Open Browser    ${URL}    chrome
    Click Button    id=add-to-cart-sauce-labs-backpack
    Sleep    2s
    Close Browser

Test Order Invalid Product
    [Documentation]    ทดสอบการสั่งซื้อสินค้าที่ไม่มีอยู่
    Open Browser    ${URL}    chrome
    Input Text    id=product-search    non_existent_product
    Sleep    2s
    Close Browser
