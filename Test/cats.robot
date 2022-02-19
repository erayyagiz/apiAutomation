*** Settings ***
Resource     ../Keyword/catsApi.robot

*** Variables ***
${CONTENT}             null
${ID_LIST}             null

*** Test Cases ***
Should Be GET Facts About the Cats
    ${content}=                                 GET Facts About the Cats
    Set Global Variable                         ${CONTENT}                             ${content}


Should Be GET Fact Details About the Cats
    @{idList}=                                  Get IDs of the Cats                    ${CONTENT}
    Set Global Variable                         @{ID_LIST}                             @{idList}


Should Be Verify the Values With Content
    @{idList}=                                  Get IDs of the Cats                    ${CONTENT}
    Verify the Values With Content              ${CONTENT}                             @{idList}


Should Be Verify the Values With Content Detail
    Verify the Values With Content Detail       @{ID_LIST}
