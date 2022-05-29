import json
import os
from apigateway_policy import ApiGateWayPolicy,HttpVerb
from authenconfig import AuthenConfig
from authorized_request import Result,AuthorizedRequest
from be_webhook import BeWebhook

authenConfig = None
authorize=None

def arrayToString(arr):
    if len(arr)==0:
        return ""
    if len(arr)==1:
        return str(arr[0])
    return ";".join(str(x) for x in arr)

def lambda_handler(event, context):
    print(str(event))
    global authenConfig
    global authorize
    
    beWebhook=BeWebhook(event['headers']['Authorization'])
    token=beWebhook.getToken()

    if authorize is None:
        loadAuthen=AuthenConfig.load_config(None)
        authenConfig = loadAuthen.get_config()
        print(authenConfig)
    # {
    #     "jwt_key":"xxxx",
    #     "db_pass":"xxxx"
    # }
    jwt_secret_key=authenConfig._sections['appSecrets']['jwt_key']
    authorize=AuthorizedRequest(jwt_secret_key)
    print("Method ARN: " + event['methodArn'])

    principalId = "social-principal"
    tmp = event['methodArn'].split(':')
    apiGatewayArnTmp = tmp[5].split('/')
    arrPath=apiGatewayArnTmp[3:]
    endpoint="/".join(arrPath)
    path="/"+apiGatewayArnTmp[3]
    print(path)
    print(" \n Call to endpoint:"+endpoint)
    httpVerb=apiGatewayArnTmp[2]
    print(" \n Http action :"+httpVerb)
    awsAccountId = tmp[4]

    # generate policy
    policy = ApiGateWayPolicy(principalId, awsAccountId)
    policy.restApiId = apiGatewayArnTmp[0]
    policy.region = tmp[3]
    policy.stage = apiGatewayArnTmp[1]
    authorizedResult=authorize.validate(token)

    if authorizedResult.result==Result.ALLOW:
        policy.allowMethod(httpVerb,path)
        context={
            "userid":authorizedResult.payload['sub'],
            "token":token
        }
    else:
        policy.denyMethod(httpVerb,path)
        context={
            "messages":authorizedResult.payload
        }

    # Finally, build the policy
    authResponse = policy.build()
    authResponse["context"] = context
    print(authResponse)
    return authResponse