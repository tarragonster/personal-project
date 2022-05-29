import requests
import json
import os

BE_API_URL=os.environ['BE_API_URL']
API_GATEWAY_URL=os.environ['API_GATEWAY_URL']

class BeWebhook:
    def __init__(self,token,userId):
        self.userId=userId
        self.token=str(token)
        self.headers={
            'Authorization': 'Bearer ' + self.token
        }

    def createNftMetaData(self,pload):
        data=pload
        response=requests.post(BE_API_URL + 'nfts/', json=pload, headers=self.headers)
        res =response.json()
        return res
