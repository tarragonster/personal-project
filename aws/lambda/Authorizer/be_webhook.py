import requests
import json
import os

BE_API_URL=os.environ['BE_API_URL']

class BeWebhook:
    def __init__(self,token):
        self.token=token
        
    def getToken(self):
        headers= {
            'authorization': 'Bearer ' + self.token,
            'x-huuk-social-access-token': self.token
        }
        
        try:
            response=requests.post(BE_API_URL + 'auth/login-lambda/', headers=headers)
            res =response.json()['data']
            return res["access_token"]
        except:
            print('error when authenticate to huuk_market')
            return None
