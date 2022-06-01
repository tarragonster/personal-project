import jwt
import datetime
import json
import logging
import urllib.parse
from enum import Enum

class Result(Enum):
    ALLOW=1
    TOKEN_EXPIRE=2
    INVALID_TOKEN=3
    UNAUTHORIZED=4
class AuthorizedResult:
    def __init__(self,result,token_payload):
        self.result=result
        self.payload=token_payload
class AuthorizedRequest:
    def __init__(self,jwt_secret_key):
        self.secret_key=jwt_secret_key
    def loadDict(self,arrObj,resultDict):
        for item in arrObj:
            dic=dict(item)
            for key, value in dic.items():
                resultDict[key]=value

    def validate(self,auth_token,endpoint,httpVerb):
        payload=None
        try:
            token=jwt.decode(auth_token,self.secret_key)
            payload=dict(token)
        except jwt.ExpiredSignatureError:
            return AuthorizedResult(Result.TOKEN_EXPIRE,"Token is expire,please re-login.")
        except jwt.InvalidTokenError:
            return AuthorizedResult(Result.INVALID_TOKEN,"Token is invalid,please re-login.")

        arrPath=urllib.parse.unquote(endpoint).split('/')
        userId=str(arrPath[1])
        print('user id in path:'+str(userId))
        print('user id in token:'+str(payload['sub']))
        if str(userId)==str(payload['sub']):
            return AuthorizedResult(Result.ALLOW,payload)
        else:
            return AuthorizedResult(Result.UNAUTHORIZED,"user id in path not map with user id in token.") 
        

