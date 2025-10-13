*** Settings ***
Resource    /saucedemo_test1/resources/keywords.robot
Library    SeleniumLibrary
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List

*** Variables ***
# @{expected_item}    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light
# @{keep_ids}    remove-sauce-labs-bike-light    remove-sauce-labs-bolt-t-shirt
@{expected_items}    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light

*** Test Cases ***
Login test
    Login with credentials    standard_user    secret_sauce    chrome
    Add product to cart    
    ...    add-to-cart-sauce-labs-bolt-t-shirt    
    ...    add-to-cart-sauce-labs-bike-light    
    ...    add-to-cart-sauce-labs-backpack
    ...    add-pla-sauce-labs-backpack
    ...    add-to-cart-test.allthethings()-t-shirt-(red)
    # Wait Until Element Is Visible    id=remove-sauce-labs-backpack    timeout=2s
    # Click cart icon
    Wait Until Element Is Visible    id=shopping_cart_container    timeout=2s
    Click Element    xpath=//a[@data-test='shopping-cart-link']
    # Keep Only These Products In Cart    @{keep_ids}
    Clean Cart And Verify Items    @{expected_items}
    # Remove product from cart    remove-sauce-labs-backpack
    # Verify cart items    
    # ...    Sauce Labs Bolt T-Shirt
    # ...    Sauce Labs Bike Light
    # Click checkout button
    Click Button    id=checkout
    Checkout with your information    panida    banyen    10130
    Click Button    id=continue
    Verify order summary in checkout overview page
    Click Button    id=finish
    Sleep    5s
    Close Browser

