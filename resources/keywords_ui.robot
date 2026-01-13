*** Settings ***
Library    SeleniumLibrary        # ใช้ควบคุม UI: เปิดเบราว์เซอร์, คลิก, พิมพ์, รอ element
Library    String                 # ใช้จัดการข้อความ: Replace String, Fetch From Right, Strip String
Library    Collections            # ใช้จัดการ list/dict: Create List, Append To List, Get From List
Library    DateTime               # ใช้ดึงเวลาปัจจุบัน, สร้าง timestamp สำหรับ log หรือชื่อไฟล์
Library    OperatingSystem        # ใช้จัดการไฟล์/โฟลเดอร์: Create Directory, Remove File, Append To File
Library    Process

*** Variables ***
${URL}    https://www.saucedemo.com/


*** Keywords ***
Login with credentials
    [Arguments]    ${username}    ${password}    ${browser}
    Run Keyword If    '${browser}' == 'chrome'    Open Chrome Without Popup    ${URL}
    ...         ELSE    Open Browser    ${URL}    ${browser}
    Maximize Browser Window
    Input Text        id=user-name    ${username}
    Input Password    id=password     ${password}
    Click Button      id=login-button
Open Chrome Without Popup
    [Arguments]    ${url}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --guest    #incognito
    Open Browser    ${url}    chrome    options=${options}
    Maximize Browser Window
Add product to cart 
    [Arguments]    @{product_ids}
    FOR    ${product}    IN    @{product_ids}
        # ดึงรายการ element ที่ตรงกับ id
        ${elements}=    Get WebElements    id=${product}
        ${count}=       Get Length         ${elements}

        IF    ${count} > 0
            Click Element    id=${product}
            Log    Added to cart: ${product}    console=yes
        ELSE
            Log    Product not found: ${product}    console=yes
        END
    END
Clean Cart And Verify Items
    [Arguments]    @{expected_items}

    ${item_names}=    Get WebElements    css=.inventory_item_name    #ดึงรายการสินค้าทั้งหมดในตะกร้า
    ${remove_buttons}=    Get WebElements    css=.cart_button    #ดึงปุ่มลบสินค้าทั้งหมดในตะกร้า
    ${count}=    Get Length    ${item_names}             #นับจำนวนสินค้าที่มีในตะกร้า

    FOR    ${index}    IN RANGE    ${count}
    ${name}=    Get Text    ${item_names[${index}]}
    ${name}=    Strip String    ${name}
    
    ${is_expected}=    Evaluate    """${name}""" in ${expected_items}
    Wait Until Page Contains Element    xpath=//button[text()="Remove"]    timeout=5s

        IF    not ${is_expected}
            Click Element    ${remove_buttons[${index}]}
            Log    Removed unexpected item from cart: ${name}    console=yes
        
        ELSE
            Log    Kept expected item in cart: ${name}    console=yes
        END
    END

    Sleep    1s

    ${final_items}=    Get WebElements    css=.inventory_item_name    #ดึงรายการสินค้าหลังลบ
    @{actual_items}=    Create List

    FOR    ${item}    IN    @{final_items}
        ${text}=    Get Text    ${item}
        ${text}=    Strip String    ${text}
        Append To List    ${actual_items}    ${text}
    END

    Should Be Equal    ${actual_items}    ${expected_items}
    Log    Final verified cart: ${actual_items}    console=yes   

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
    Log    Order summary verified: Item=${item_total}, Tax=${tax}, Total=${total}    console=yes
   
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
    
Run Step With Logging
    [Arguments]    ${step}    ${keyword}    @{args}
    # 1. กำหนด Timestamp ก่อนเริ่มรัน Keyword เพื่อใช้ในการ Log และตั้งชื่อไฟล์ Screenshot
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S  # <-- ปรับ format ให้ไม่มีเครื่องหมายที่ไม่รองรับในชื่อไฟล์ (เช่น :)
    # 2. รัน Keyword หลักและจับ Error
    ${status}    ${msg}=    Run Keyword And Ignore Error    ${keyword}    @{args}
    # 3. ถ่ายภาพหน้าจอหลังการรัน Keyword (ไม่ว่า Pass หรือ Fail)
    ${filename}=    Set Variable    ${step}_${timestamp}_${status}.png
    Run Keyword And Ignore Error    Capture Page Screenshot    ${filename}    # <-- เพิ่มส่วนนี้ (ใช้ Ignore Error เพื่อป้องกันไม่ให้ Keyword นี้ Fail ตาม)
    # 4. Log ผลลัพธ์ลงในไฟล์ภายนอก
    ${log_line}=    Catenate    SEPARATOR= |    ${timestamp}    ${step}    ${status}
    Append To File    ${RESULT_FILE}    ${log_line}\n
    # 5. สั่ง Fail ถ้า Keyword หลักล้มเหลว
    Run Keyword If    '${status}' == 'FAIL'    Fail    ${msg}

Capture Screenshot With Unique Name
    [Arguments]    ${step_name}
    # 1. ดึงวันที่และเวลาปัจจุบันเพื่อใช้เป็นชื่อไฟล์
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    
    # 2. กำหนดชื่อไฟล์ให้ไม่ซ้ำ: [ชื่อขั้นตอน]_[วันที่_เวลา].png
    ${filename}=    Set Variable    ${step_name}_${timestamp}.png
    
    # 3. สั่งถ่ายภาพหน้าจอ
    Capture Page Screenshot    ${filename}