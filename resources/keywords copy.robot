*** Settings ***
Library    SeleniumLibrary
Library    String     # for Replace String,  Fetch From Right, Strip String
Library    Collections    # for  Append To List


*** Variables ***
${URL}    https://www.saucedemo.com/
# @{expected_item}    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light
#${expected_item}=    Create List    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light
# @{keep_ids}    remove-sauce-labs-bike-light    remove-sauce-labs-bolt-t-shirt
   
*** Keywords ***
Login with credentials
    [Arguments]    ${username}    ${password}
    Open Browser    ${URL}    edge
    Input Text        id=user-name    ${username}
    Input Password    id=password     ${password}
    Click Button      id=login-button

Add product to cart
    [Arguments]    @{Product_id}
    FOR    ${product}    IN    @{Product_id}
        ${id}=    Set Variable    ${product}
        ${results}=    Run Keyword And Return Status    Element Should Be Visible    id=${id}
        IF    ${results}
            Click Button    id=${id}
            Log    Added to cart: ${product}
        ELSE
            Log    Product not found: ${product}
            Log To Console    Product not found: ${product}
        END       
    END

# Remove product from cart    # ระบุสินค้าที่ต้องการให้ remove
#     [Arguments]    @{Product_id}
#     FOR    ${product}    IN    @{Product_id}
#         ${id}=    Set Variable    ${product}
#         Log    ${id}
#         Click Button    id=${id}
#     END

Clean Cart And Verify Items
    [Arguments]    @{expected_items}

    ${item_names}=    Get WebElements    css=.inventory_item_name
    ${remove_buttons}=    Get WebElements    css=.cart_button
    ${count}=    Get Length    ${item_names}

    FOR    ${index}    IN RANGE    ${count}
        ${name}=    Get Text    ${item_names[${index}]}
        ${name}=    Strip String    ${name}
        ${is_expected}=    Run Keyword And Return Status    List Should Contain Value    ${expected_items}    ${name}
        IF    not ${is_expected}
            Click Element    ${remove_buttons[${index}]}
        
            Log    ❌ Removed unexpected item from cart: ${name}    console=yes
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

# Verify cart items
#     [Arguments]    @{expected_items}
#     ${cart_items}=    Get WebElements    css=.inventory_item_name
#     @{actual_items}=    Create List

#     FOR    ${item}    IN    @{cart_items}
#         ${name}=    Get Text    ${item}
#         Append To List    ${actual_items}    ${name}
#     END    
    
#     Should Be Equal    ${actual_items}    ${expected_items}
#     Log To Console    Cart items verified: ${actual_items}    

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


    