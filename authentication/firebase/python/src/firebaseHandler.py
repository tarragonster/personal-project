import requests
import json
import firebase_admin
from firebase_admin import credentials, auth
from service_account_key import ServiceAccountKey

serviceAccountKey = ServiceAccountKey()
key=serviceAccountKey.accountKey()

cred = credentials.Certificate(key)
firebase_admin.initialize_app(cred)
user = auth.get_user_by_email("tug.thanh@gmail.com")

print(json.dumps(user.__dict__))
print(json.dumps(user.email))