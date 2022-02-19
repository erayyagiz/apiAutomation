*** Settings ***
Resource    ../Resource/base.robot

*** Keywords ***
GET Facts About the Cats
    Create Session           cats                   ${BASE_URL}              disable_warnings=1
    ${response}=             GET On Session         cats                     /facts
    Log                      ${response.content}
    Status Should Be         200                    ${response}
    [Return]                 ${response}


GET Fact Details About the Cats
    [Arguments]              ${id}
    Create Session           cats                   ${BASE_URL}              disable_warnings=1
    ${response}=             GET On Session         cats                     /facts/${id}
    Log                      ${response.content}
    Status Should Be         200                    ${response}
    [Return]                 ${response}


GET Values in the CSV Files
    [Arguments]      ${id}
    ${lines}=        Read the CSV File
    ${cntLines}=     Get length                  ${lines}
    @{headers}=      Split String                ${lines}[0]                      |
    ${cntHeaders}=   Get length                  ${headers}
    ${jsonList}=     Create Dictionary
    FOR              ${i}                        IN RANGE                         1                     ${cntLines}
                     FOR                         ${j}                             IN RANGE              ${cntHeaders}
                                                 @{line1}=                        Split String          ${lines}[${i}]                     |
                                                 Set To Dictionary                ${jsonList}           ${headers}[${j}]=${line1}[${j}]
                     END
                     Exit For Loop If            "${jsonList._id}" == "${id}"
    END
    Log             ${jsonList}
    [Return]        ${jsonList}


Get IDs of the Cats
    [Arguments]     ${content}
    ${idList}=      Get Value From Json Response Content      ${content}                                $.._id
    @{idList}=      Convert To List                           ${idList}
    [Return]        @{idList}


Verify the Values With Content
    [Arguments]     ${content}                                @{idList}
    Log             ${content.content}
    FOR             ${id}                                     IN                                        @{idList}
                    ${data}=                                  GET Values in the CSV Files               ${id}
                    ${user}=                                  Get Value From Json Response Content      ${content}            $[?(@._id=='${id}')].user
                    ${text}=                                  Get Value From Json Response Content      ${content}            $[?(@._id=='${id}')].text
                    ${type}=                                  Get Value From Json Response Content      ${content}            $[?(@._id=='${id}')].type
                    Log                                       ${user}[0] ?= ${data.user}
                    Log                                       ${text}[0] ?= ${data.text}
                    Log                                       ${type}[0] ?= ${data.type}
                    Should be Equal                           ${user}[0]                                ${data.user}
                    Should be Equal                           ${text}[0]                                ${data.text}
                    Should be Equal                           ${type}[0]                                ${data.type}
    END


Verify the Values With Content Detail
    [Arguments]     @{idList}
    FOR             ${id}                                     IN                                        @{idList}
                    ${content}=                               GET Fact Details About the Cats           ${id}
                    Log                                       ${content.content}
                    ${data}=                                  GET Values in the CSV Files               ${id}
                    ${firstName}=                             Get Value From Json Response Content      ${content}            $.user.name.first
                    ${lastName}=                              Get Value From Json Response Content      ${content}            $.user.name.last
                    Log                                       ${firstName}[0] ?= ${data.first}
                    Log                                       ${lastName}[0] ?= ${data.last}
                    Should be Equal                           ${firstName}[0]                            ${data.first}
                    Should be Equal                           ${lastName}[0]                             ${data.last}
    END
