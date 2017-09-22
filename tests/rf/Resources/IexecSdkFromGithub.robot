*** Settings ***
Library  Process
Library  OperatingSystem
Library  String

*** Variables ***
${IEXEC_SDK_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-sdk.git
${IEXEC_SDK_FORCE_GIT_CLONE} =  false
${IEXEC_SDK_DISTRIB}

*** Keywords ***

Init Sdk
    Run Keyword If  '${IEXEC_SDK_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Sdk
    Npm Install Iexec Sdk

Git Clone Iexec Sdk
    Remove Directory  iexec-sdk  recursive=true
    ${git_result} =  Run Process  git clone ${IEXEC_SDK_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Npm Install Iexec Sdk
    ${npm_result} =  Run Process  cd iexec-sdk && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    Set Suite Variable  ${IEXEC_SDK_DISTRIB}  iexec-sdk/dist/iexec.js
    File Should Exist  ${IEXEC_SDK_DISTRIB}
    Iexec  --version
    Iexec  --help


Iexec
    [Arguments]  ${args}
    ${iexec_result} =  Run Process  ${IEXEC_SDK_DISTRIB} ${args}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}

Iexec An app
    [Arguments]  ${directory}  ${args}
    ${iexec_result} =  Run Process  cd ${directory} && ../${IEXEC_SDK_DISTRIB} ${args}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}


Iexec Init An App
    [Arguments]  ${appName}
    ${iexec_result} =  Run Process  ${IEXEC_SDK_DISTRIB} init ${appName}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}