*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    Process
Library    SeleniumLibrary
Library    DateTime
Library    OperatingSystem

*** Variables ***
${BASE_URL}         https://cat-fact.herokuapp.com/


*** Keywords ***
Read the CSV File
    ${csv}=          Get File                    ${EXEC_DIR}/Csv/data.csv
    @{read}=         Create List                 ${csv}
    @{lines}=        Split To Lines              @{read}
    [Return]         ${lines}



Get Body From Json File
    [Arguments]     ${jsonFileName}
    ${jsonBody}=    Load Json From File         ${EXEC_DIR}/Json/${jsonFileName}.json
    Log             ${jsonBody}
    [Return]        ${jsonBody}


Get Value From Json File
    [Arguments]     ${jsonFileName}             ${content}
    ${jsonFile}=    Get Body From Json File     ${jsonFileName}
    ${val}=         Get From Dictionary         ${jsonFile}             ${content}
    Log             ${val}
    [Return]        ${val}


Get Value From Dictionary Response Content
    [Arguments]     ${response}                 ${content}
    ${val}=         Convert String To Json      ${response.content}
    ${val}=         Get From Dictionary         ${val}                  ${content}
    Log             ${val}
    [Return]        ${val}


Get Value From Json Response Content
    [Arguments]     ${response}                 ${content}
    ${val}=         Convert String To Json      ${response.content}
    ${val}=         Get Value From Json         ${val}                  ${content}
    Log             ${val}
    [Return]        ${val}



