*** Settings ***
Library    SeleniumLibrary
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List
Library    DateTime
Library    OperatingSystem

*** Variables ***
${URL}    https://www.saucedemo.com/
${LOG_DIR}        logs
${LOG_FILE}       ${LOG_DIR}/test_results.txt

*** Keywords ***
Login with credentials
    [Arguments]    ${username}    ${password}    ${browser}
    Run Keyword If    '${browser}' == 'chrome'    Open Chrome Without Popup    ${URL}
    ...    ELSE    Open Browser    ${URL}    ${browser}
    Input Text        id=user-name    ${username}
    Input Password    id=password     ${password}
    Click Button      id=login-button
Open Chrome Without Popup
    [Arguments]    ${url}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # ${prefs}=    Create Dictionary
    # ...    credentials_enable_service=False
    # ...    profile.password_manager_enabled=False
    # ...    profile.default_content_setting_values.notifications=2

    # Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Call Method    ${options}    add_argument    --guest    #incognito
    # Call Method    ${options}    add_argument    --disable-popup-blocking
    # Call Method    ${options}    add_argument    --disable-infobars
    # Call Method    ${options}    add_argument    --start-maximized

    Open Browser    ${url}    chrome    options=${options}


# Login with credentials
#     [Arguments]    ${username}    ${password}
#     Open Browser    ${URL}    edge
#     Input Text        id=user-name    ${username}
#     Input Password    id=password     ${password}
#     Click Button      id=login-button


Add product to cart
    [Arguments]    @{Product_id}
    FOR    ${product}    IN    @{Product_id}
        ${id}=    Set Variable    ${product}
        ${status}=    Run Keyword And Return Status    Page Should Contain Element    id=${id}

        IF    ${status}
            Click Button    id=${id}
            Log    ✅ Added to cart: ${product}
        ELSE
            Log    ⚠️ Product not found (expected): ${product}
            Log To Console    Product not found (expected): ${product}
        END
    END
    
    

# Remove product from cart    # ระบุสินค้าที่ต้องการให้ remove
#     [Arguments]    @{Product_id}
#     FOR    ${product}    IN    @{Product_id}
#         ${id}=    Set Variable    ${product}
#         Log    ${id}
#         Click Button    id=${id}
#     END

# Clean Cart And Verify Items
Clean Cart And Verify Items
    [Arguments]    @{expected_items}

    ${item_names}=    Get WebElements    css=.inventory_item_name
    ${remove_buttons}=    Get WebElements    css=.cart_button
    ${count}=    Get Length    ${item_names}

    FOR    ${index}    IN RANGE    ${count}
    ${name}=    Get Text    ${item_names[${index}]}
    ${name}=    Strip String    ${name}
    
    ${is_expected}=    Evaluate    """${name}""" in ${expected_items}
    Wait Until Page Contains Element    xpath=//button[text()="Remove"]    timeout=5s


    IF    not ${is_expected}
        Click Element    ${remove_buttons[${index}]}
        Log    ❌ Removed unexpected item from cart: ${name}    console=yes
        Log To Console    Remove buttons: ${remove_buttons}
        
    ELSE
        Log    ✅ Kept expected item in cart: ${name}    console=yes
    END
    END

    Sleep    1s

    ${final_items}=    Get WebElements    css=.inventory_item_name
    @{actual_items}=    Create List

    FOR    ${item}    IN    @{final_items}
        ${text}=    Get Text    ${item}
        ${text}=    Strip String    ${text}
        Append To List    ${actual_items}    ${text}
    END

    Should Be Equal    ${actual_items}    ${expected_items}
    Log    🟢 Final verified cart: ${actual_items}    console=yes

Verify cart items
    [Arguments]    @{expected_items}
    ${cart_items}=    Get WebElements    css=.inventory_item_name
    @{actual_items}=    Create List

    FOR    ${item}    IN    @{cart_items}
        ${name}=    Get Text    ${item}
        Append To List    ${actual_items}    ${name}
    END    
    
    Should Be Equal    ${actual_items}    ${expected_items}
    Log To Console    Cart items verified: ${actual_items}    

Checkout with your information
    [Arguments]    ${Firstname}    ${Lastname}    ${Zipcode}
    Input Text     id=first-name    ${Firstname}
    Input Text    id=last-name    ${Lastname}
    Input Text    id=postal-code    ${Zipcode}

Verify order summary in checkout overview page
    ${item_total_text}=    Get Text    class=summary_subtotal_label
    ${tax_text}=           Get Text    class=summary_tax_label
    ${total_text}=         Get Text    class=summary_total_label

    ${item_total}=         Convert Price Text To Number    ${item_total_text}
    ${tax}=                Convert Price Text To Number    ${tax_text}
    ${total}=              Convert Price Text To Number    ${total_text}

    ${expected_tax}=       Evaluate    round(${item_total} * 0.08, 2)
    ${expected_total}=     Evaluate    round(${item_total} + ${expected_tax}, 2)

    Should Be Equal As Numbers    ${tax}    ${expected_tax}
    Should Be Equal As Numbers    ${total}    ${expected_total}
    Log To Console    Order summary verified: Item=${item_total}, Tax=${tax}, Total=${total}
   
Convert Price Text To Number
    [Arguments]    ${text}
    # ตัวอย่าง: "Item total: $39.98" → เอาเฉพาะ 39.98
    ${price_str}=    Replace String    ${text}    $    ${EMPTY}    # เอา $ ออก
    ${price}=        Fetch From Right    ${price_str}    :    
    ${price}=        Strip String    ${price}
    ${price}=        Convert To Number    ${price}
    RETURN    ${price}

Create Log File Path
    ${datetime}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${folder}=      Set Variable    results/${datetime}
    Create Directory    ${folder}
    ${file}=         Set Variable    ${folder}/run_log_${datetime}.txt
    Set Suite Variable    ${RESULT_FILE}    ${file}
    Log    Log file will be: ${RESULT_FILE}

Log To Text File
    [Arguments]    ${message}
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H%M%S
    ${line}=         Catenate    SEPARATOR= |     ${timestamp}    ${message}
    Append To File   ${RESULT_FILE}    ${line}\n
    