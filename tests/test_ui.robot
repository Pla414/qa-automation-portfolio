*** Settings ***
Resource    /saucedemo_test1/resources/keywords_ui.robot
Library    Process
Library    SeleniumLibrary        # ใช้ควบคุม Web UI เช่น click, input, wait, open browser
Library    String                 # ใช้จัดการข้อความ เช่น Replace String, Fetch From Right, Strip String
Library    Collections            # ใช้จัดการ list/dict เช่น Create List, Append To List
Library    DateTime               # ใช้ดึงวันที่-เวลา เพื่อใส่ timestamp ลง log หรือชื่อไฟล์
Library    OperatingSystem        # ใช้จัดการไฟล์และโฟลเดอร์ เช่น Create Directory, Append To File
Library    JSONLibrary            # ใช้แปลง JSON และเข้าถึงข้อมูล JSON เช่น To JSON, Get Value
Library    RequestsLibrary        # ใช้ทำ API request เช่น GET, POST, PUT, DELETE (รองรับ UI + API test)
Library    ScreenCapLibrary


*** Variables ***
@{expected_items}    Sauce Labs Bolt T-Shirt    Sauce Labs Bike Light

*** Test Cases ***
Verify User Can Place Order Successfully
# ----------------Test set up---------------------
    Create Log File Path
    Start Video Recording    # เริ่มบันทึกวิดีโอ

    Run Step With Logging    Login with credentials    Login with credentials    standard_user    secret_sauce    chrome   #chrome edge 
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

    Stop Video Recording

    Close Browser