*** Settings ***
Documentation    Launch katacoda scenario on ropsten, kovan and rinkeby. to check all test chain ok
Resource  ../Resources/IexecSdk.robot
Library           OperatingSystem
Library           ArchiveLibrary
Suite Setup  Init Ping Katacoda


# to launch tests :
# pybot --variable PKEY:aprivatekey -d Results ./tests/rf/Ping/isKatacodaScenarioAlive.robot

*** Variables ***
${PKEY}


*** Test Cases ***


Test Deploy And Submit Katacoda Factorial Scenario On Kovan
    [Documentation]  Test Katacoda Hello World Scenario On Kovan
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network kovan
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network kovan
    IexecSdk.Iexec An App  iexec-factorial  account login --network kovan
    IexecSdk.Iexec An App  iexec-factorial  deploy --network kovan
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  submit 10 --network kovan
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stderr}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  5 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network kovan


Test Submit Katacoda Factorial Scenario On Kovan
    [Documentation]  Test Katacoda Hello World Scenario On Kovan
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network kovan
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network kovan
    IexecSdk.Iexec An App  iexec-factorial  account login --network kovan
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  submit 10 --network kovan
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stderr}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  5 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network kovan


Test Deploy And Submit Katacoda Factorial Scenario On Ropsten
    [Documentation]  Test Katacoda Hello World Scenario On Ropsten
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC
    IexecSdk.Iexec An App  iexec-factorial  account login
    IexecSdk.Iexec An App  iexec-factorial  deploy
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  submit 10
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stderr}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network ropsten

Test Submit Katacoda Factorial Scenario On Ropsten
    [Documentation]  Test Katacoda Hello World Scenario On Ropsten
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC
    IexecSdk.Iexec An App  iexec-factorial  account login
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  submit 10
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stderr}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network ropsten


Test Deploy And Submit Katacoda Factorial Scenario On Rinkeby
    [Documentation]  Test Katacoda Hello World Scenario On Rinkeby
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  account login --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  deploy --network rinkeby
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  submit 10 --network rinkeby
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stderr}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network rinkeby

Test Submit Katacoda Factorial Scenario On Rinkeby
    [Documentation]  Test Katacoda Hello World Scenario On Rinkeby
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  account login --network rinkeby
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  submit 10 --network rinkeby
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stderr}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network rinkeby


*** Keywords ***

Init Ping Katacoda
    IexecSdk.Init Sdk

Prepare Iexec Factorial
    ${rm_result} =  Run Process  rm -rf iexec-factorial  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdk.Iexec Init An App  factorial
    IexecSdk.Iexec An App  iexec-factorial  wallet create
    Run  sed -i 's/.*\"privateKey\":.*/\"privateKey\":\"${PKEY}\",/g' iexec-factorial/wallet.json


Check Factorial 10 In Result
    [Arguments]  ${transactionHash}  ${network}
    ${stdout} =  IexecSdk.Iexec An App  iexec-factorial  result ${transactionHash} ${network} --save
    ${count_zip} =	Count Files In Directory  iexec-factorial  *.zip
    ${count_txt} =  Count Files In Directory  iexec-factorial  *.text
    ${sum}=  Evaluate  int(${count_zip}) + int(${count_txt})
    Should Be True  ${sum} > 0
    Run Keyword If  ${count_zip} > 0  Check Factorial ZIP  ${transactionHash}
    Run Keyword If  ${count_txt} > 0  Check Factorial TXT  ${transactionHash}


Check Factorial TXT
    [Arguments]  ${transactionHash}
    ${result} =  Get File  iexec-factorial/${transactionHash}.text
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Check Factorial ZIP
    [Arguments]  ${transactionHash}
    Extract Zip File  iexec-factorial/${transactionHash}.zip  iexec-factorial/zipout
    ${result} =  Get File  iexec-factorial/zipout/stdout.txt
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
