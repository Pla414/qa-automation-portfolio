*** Settings ***
Resource    /saucedemo_test1/resources/keywords_ui.robot
Library    SeleniumLibrary
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List
Library    DateTime    # for date time
Library    OperatingSystem    # for files

Library    JSONLibrary    # ใช้ To JSON แปลง content ให้เข้าถึงข้อมูลได้
Library    RequestsLibrary

*** Variables ***
@{expected_items}    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light

*** Test Cases ***
Verify User Can Place Order Successfully
    Create Log File Path
    Run Step With Logging    Login with credentials    Login with credentials    standard_user    secret_sauce    edge    #chrome

    Run Step With Logging    Add product to cart    Add product to cart
    ...    add-to-cart-sauce-labs-bolt-t-shirt
    ...    add-to-cart-sauce-labs-bike-light
    ...    add-to-cart-sauce-labs-backpack
    ...    add-pla-sauce-labs-backpack
    ...    add-to-cart-test.allthethings()-t-shirt-(red)

    Wait Until Element Is Visible    id=shopping_cart_container    timeout=2s
    Run Step With Logging    Click cart icon    Click Element    xpath=//a[@data-test='shopping-cart-link']

    Run Step With Logging    Clean and verify cart    Clean Cart And Verify Items    @{expected_items}
    Run Step With Logging    Click checkout    Click Button    id=checkout

    Run Step With Logging    Fill in user info    Checkout with your information    panida    banyen    10130
    Run Step With Logging    Click continue    Click Button    id=continue

    Run Step With Logging    Verify order summary    Verify order summary in checkout overview page
    Run Step With Logging    Click finish    Click Button    id=finish

    Sleep    2s
    Close Browser



