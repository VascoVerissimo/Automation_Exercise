*** Settings ***
Library           SeleniumLibrary

Suite Setup       Open Browser to URL    ${URL}
Suite Teardown    Close Browser

*** Variables ***
${URL}     http://automationexercise.com

*** Test Cases ***
Search And Add 2 Products To Cart
    [Documentation]    This test verifies that a user can search for a men t-shirt
    ...    and a sleeveless dress and add items to the cart.
    
    Navigate To Products Page
    Verify Search Bar Is Visible
    Search For Product    Men Tshirt
    Verify Search Results    Men Tshirt
    Add Product To Cart
    Navigate To Products Page
    Verify Search Bar Is Visible
    Close Ads If Presented
    Search For Product    Sleeveless Dress
    Verify Search Results    Sleeveless Dress
    Add Product To Cart
    Go To Cart
    Verify Products In Cart    2
    Verify Total Price Correct    1400

*** Keywords ***
Accept Cookies If Presented
    [Documentation]    Checks for a cookie acceptance pop-up and clicks the consent button
    
    ${is_present}    Run Keyword And Return Status    Wait Until Element Is Visible    css:.fc-button.fc-cta-consent.fc-primary-button    3s
    Run Keyword If    ${is_present}    Click Element    css:.fc-button.fc-cta-consent.fc-primary-button

Close Ads If Presented
    [Documentation]    Reloads the page to remove popup ad
    
    Sleep    3s
    Reload Page
    Sleep    3s

Open Browser to URL
    [Arguments]    ${URL}
    
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Accept Cookies If Presented

Navigate To Products Page
    Scroll Element Into View    css:a[href='/products']
    Click Element    css:a[href='/products']

Verify Search Bar Is Visible
    Page Should Contain Element    id:search_product

Search For Product
    [Arguments]    ${product}
    
    Input Text    id:search_product    ${product}
    Click Element    id:submit_search

Verify Search Results
    [Arguments]    ${product}
    Wait Until Element Is Visible    xpath://*[contains(text(), '${product}')]    5s

Add Product To Cart
    Scroll Element Into View    id=susbscribe_email
    Mouse Over    css:.product-image-wrapper
    Wait Until Element Is Visible    css:.btn.btn-default.add-to-cart
    Click Element    css=.add-to-cart:nth-child(3)
    Wait Until Element Is Visible    css=.btn-success
    Click Element    css=.btn-success

Go To Cart
    Scroll Element Into View    css:a[href="/view_cart"]
    Click Element    css:a[href="/view_cart"]

Verify Products In Cart
    [Arguments]    ${count}

    ${items_cart}    Get Element Count    xpath://a[contains(@href, 'product_details')]
    Should Be Equal As Numbers    ${items_cart}    ${count}

Verify Total Price Correct
    [Arguments]    ${total}

    @{elements}    Get WebElements    css:p.cart_total_price
    ${total_sum}    Set Variable    0

    FOR    ${element}    IN    @{elements}
        ${price_text}    Get Text    ${element}
        ${number}    Evaluate    int(''.join([d for d in $price_text if d.isdigit()]))
        ${total_sum}    Evaluate    ${total_sum} + ${number}
        Log    total sum = ${total_sum}
    END

    Should Be Equal As Integers    ${total_sum}    ${total}
