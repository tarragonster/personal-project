# API Gateway

## Study 1:
#### 1.1 Context:
- Study authentication with usage of python lambda apigateway
#### 1.2 Issue:
- TODO
#### 1.3 Why should you care?:
- Understand lambda authorizer development process
- Love to adding this to my collection
#### 1.4 Solution:
- Analyse current codebase
    + Detect entrypoint -> build a function tree
    + Define function (input and outcome), give name
- Research on codebase component and gather resources
    + Search for terminology
    + Search for used tool
    + Search for references
    + Note on function tree
- Planning to write small simple demo
    + Use function tree as reference

#### 1.5 Function tree

```
event: input from apigatway
AuthenConfig: load config from ssm -> extract jwt
  os: interact with env
  boto3: interact with aws service
  json: incorporate with json format
  configparser: read and write from config file
  aws_xray_sdk: AWS X-Ray is a service that collects data about requests that your application serves
  traceback2: extract, format and print stack traces of Python programs
AuthorizedRequest: validate(auth_token,endpoint,httpVerb) -> result + payload validate jwt token
  loadDict: 
    dict: convert to json
  validate
    jwt: jwt library to decode + exception
    urllib.parse(): for parsing url
    AuthorizedResult: construct object json with enum result + paylod
ApiGateWayPolicy(principalId, awsAccountId): to generate a apigateway policy
  allowMethod: pass authen
  denyMethod: fail authen
  build: message return
  
handler
  event
  AuthenConfig
    os
    json
    configparser
    aws_xray_sdk.core import patch_all
    traceback.print_exc()
  AuthorizedRequest
    loadDict
      dict
    validate
      jwt
      urllib.parse()
      AuthorizedResult
  ApiGateWayPolicy
```


## Reference
[Code] awslabs - [aws-apigateway-lambda-authorizer-blueprints](https://github.com/awslabs/aws-apigateway-lambda-authorizer-blueprints/blob/master/blueprints/python/api-gateway-authorizer-python.py) \
[Use API Gateway Lambda authorizers](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html) \
[Configure a Lambda authorizer using the API Gateway console](https://docs.aws.amazon.com/apigateway/latest/developerguide/configure-api-gateway-lambda-authorization-with-console.html) \
[Secure your API Gateway with Lambda Authorizer](https://www.youtube.com/watch?v=al5I9v5Y-kA) \
[openbanking-brazilian-auth-samples](https://github.com/aws-samples/openbanking-brazilian-auth-samples) \
[Use API Gateway Lambda authorizers](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html) \

[Set up Lambda proxy integrations in API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html) \
[Gateway responses in API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-gatewayResponse-definition.html) \
[API Gateway mapping template and access logging variable reference](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html#input-variable-reference) \
[Output from an Amazon API Gateway Lambda authorizer](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-lambda-authorizer-output.html) \

[http-client webstorm](https://www.youtube.com/watch?v=1iFohqNr0oI)
##Problem
1. use multipart/form-data with api gateway
    - use Lambda proxy integrations in Api gateway
    - Method Request -> HTTP Request Headers: Accept, Content-Length, Content-Type
    - Setting -> Binary Media Types: ```*/* (all type)```, ```image/jpg (jpg type)```
    - Ref: [POSTing Binary or Multipart Form-Data to an API in Amazon API Gateway](https://harishkm.in/2020/08/26/posting-binary-or-multipart-form-data-to-an-api-in-amazon-api-gateway/)
    - Gateway won’t take more than 10 MB & Lambda won’t go over 6 MB. So this solution is fine for smaller files, but not suitable for larger files
2. passing ```context``` from authorizer to following https or lambda
   - no proxy:
      + choose token or request authorizer
      + pass data as context in authorizer ```authResponse["context"] = context```
      + use mapping template. Example:
      ```
     {
        "userid": $context.authorizer.userid,
        "token": "$context.authorizer.token",
        "body": $input.json('$')
     }
     ```
   - with proxy:
      + If you're using lamda-proxy, you can access the context from your 
        ```event.requestContext.authorizer.abc```
        
   - Ref: [How to pass API Gateway authorizer context to a HTTP integration](https://stackoverflow.com/questions/45631758/how-to-pass-api-gateway-authorizer-context-to-a-http-integration)     
3. Could not parse request body into json: Unexpected character (\'-\' (code 45))
   - must load ```multipart_content['data']``` as json and just assign 1 key
   ```
   json.loads(multipart_content['data'])['meta']
   
   right
       {
            meta: {}
       }
   
   wrong
       {
           meta: {}
           meta1: {}
           meta2: {}
       }
   ```

4. How to access http headers in custom authorizer AWS lambda function
    - by using an Authoriser of type 'Request' instead of Token
    - Ref: https://stackoverflow.com/questions/38596366/how-to-access-http-headers-in-custom-authorizer-aws-lambda-function

5. Pass authorization token to incoming request
   - TOKEN type, you must specify a custom header as the Token Source when you configure the authorizer for your API
   - Upon receiving the incoming method request, API Gateway extracts the token from the custom header
   - It then passes the token as the authorizationToken property of the event object of the Lambda function
   - Ref: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-lambda-authorizer-input.html

6. AWS API Gateway with Lambda proxy always produces base64 string response
   - Ref: [proxy always produces base64](https://stackoverflow.com/questions/53510286/aws-api-gateway-with-lambda-proxy-always-produces-base64-string-response)
    
7. Lambda-Proxy vs Lambda Integration in AWS API Gateway
    - [Lambda Integration in AWS API Gateway](https://medium.com/@lakshmanLD/lambda-proxy-vs-lambda-integration-in-aws-api-gateway-3a9397af0e6d)
    
8. Return error and response lambda-proxy
    - If the function output is of a different format, API Gateway returns a 502 Bad Gateway error response.
    - To return a response in a Lambda function in Node.js, you can use commands such as the following:
    - To return a successful result, call callback(null, {"statusCode": 200, "body": "results"}).
    - To throw an exception, call callback(new Error('internal server error')).
    - For a client-side error (if, for example, a required parameter is missing), you can call callback(null, {"statusCode": 400, "body": "Missing parameters of ..."}) to return the error without throwing an exception.
    - Ref: [set up lambda-proxy integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format)
    


