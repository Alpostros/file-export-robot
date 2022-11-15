*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    file.py

*** Variables ***
${browser}  chrome
${downloadpath}    /home/robot/app/Default-organization/clmExport/TestCases/downloads-new/
${csvPath}  /home/robot/app/Default-organization/clmExport/TestCases/docs/mtn-files-and-links.csv

*** Test Cases ***
LoginAndDownload
    ParseCSV
    
*** Keywords ***
AuthenticateUser
    Click Element    //*[@id="jazz_app_internal_LoginWidget_0_userId"]
    Input Text    //*[@id="jazz_app_internal_LoginWidget_0_userId"]    username
    Click Element    //*[@id="jazz_app_internal_LoginWidget_0_password"]
    Input Text    //*[@id="jazz_app_internal_LoginWidget_0_password"]    password
    Click Element    //*[@id="jazz_app_internal_LoginWidget_0"]/div[1]/div[1]/div[3]/form/button

DownloadAndRenameFile
    [Arguments]    ${url}    ${fileName}    ${id}    ${fileExtension}  
    SeleniumLibrary.Goto    ${url}
    ${xpathexists}=  Run Keyword And Return Status    Element Should Be Visible   //*[@id="jazz_app_internal_LoginWidget_0_userId"]        
    Run Keyword If    ${xpathexists}    AuthenticateUser
    Wait Until Created    ${downloadpath}${fileName}	10m  
    Move File    ${downloadpath}${fileName}    ${downloadpath}${id}${fileExtension}
    
ParseCSV
    ${chromeOptions}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}    Create Dictionary    download.default_directory=${downloadpath}        safebrowsing.enabled=true        download.prompt_for_download=false    download.extensions_to_open='msg'
    
    Call Method    ${chromeOptions}    add_experimental_option    prefs    ${prefs}    
    Call Method    ${chromeOptions}    add_argument    --safebrowsing-disable-download-protection
    Call Method    ${chromeOptions}    add_argument    --disable-extensions
    Call Method    ${chromeOptions}    add_argument    --safebrowsing-disable-extension-blacklist

    Create Webdriver    Chrome    chrome_options=${chromeOptions}
    ${csv}    Get File    ${csvPath}
    @{read}=    Create List    ${csv}
    @{lines}=    Split To Lines    @{read}    1
    FOR    ${line_csv}    IN    @{lines}
        @{split}    Split String    ${line_csv}    ;
        ${id}    Set Variable    ${split}[0]
        ${fileName}    Set Variable    ${split}[1]
        ${url}    Set Variable    ${split}[2]
        Log To Console    \n${fileName}${id}
        ${fileExtension}    Evaluate    file.file_ext($fileName)
        ${fileNotExists}=  Run Keyword And Return Status    File Should Not Exist   ${downloadpath}${id}${fileExtension}
		Run Keyword If    ${fileNotExists} is True
        ...   DownloadAndRenameFile    ${url}    ${fileName}    ${id}    ${fileExtension}
        ...   ELSE
        ...   Log To Console    Skipping download, file exists!
        
    END
    SeleniumLibrary.Close Browser
