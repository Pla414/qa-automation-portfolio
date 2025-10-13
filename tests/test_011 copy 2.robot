*** Settings ***
Resource    /saucedemo_test1/resources/keywords.robot
Library    SeleniumLibrary
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List
Library    DateTime    # for date time
Library    OperatingSystem    # for files


*** Variables ***
@{expected_items}    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light

*** Test Cases ***
Verify User Can Place Order Successfully
    Create Log File Path
    Log To Text File    Start login test

    Login with credentials    standard_user    secret_sauce    edge    #chrome
    Log To Text File    Login with credentials

    Add product to cart    
    ...    add-to-cart-sauce-labs-bolt-t-shirt    
    ...    add-to-cart-sauce-labs-bike-light    
    ...    add-to-cart-sauce-labs-backpack
    ...    add-pla-sauce-labs-backpack
    ...    add-to-cart-test.allthethings()-t-shirt-(red)
    Log To Text File    Add product to cart
    Wait Until Element Is Visible    id=shopping_cart_container    timeout=2s
    # Click cart icon
    Click Element    xpath=//a[@data-test='shopping-cart-link']

    Clean Cart And Verify Items    @{expected_items}
    Click Button    id=checkout
    
    Checkout with your information    panida    banyen    10130
    Click Button    id=continue

    Verify order summary in checkout overview page
    Click Button    id=finish

    Sleep    2s
    Close Browser

