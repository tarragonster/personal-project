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

    def validate(self,auth_token):
        payload=None
        if auth_token is None:
            return AuthorizedResult(Result.TOKEN_EXPIRE,"Token is expire,please re-login.")
        try:
            token=jwt.decode(auth_token,self.secret_key)
            payload=dict(token)
            return AuthorizedResult(Result.ALLOW,payload)
        except jwt.ExpiredSignatureError:
            return AuthorizedResult(Result.TOKEN_EXPIRE,"Token is expire,please re-login.")
        except jwt.InvalidTokenError:
            return AuthorizedResult(Result.INVALID_TOKEN,"Token is invalid,please re-login.")

