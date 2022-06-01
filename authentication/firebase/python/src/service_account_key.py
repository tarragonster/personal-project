import os
import json
from dotenv import load_dotenv
load_dotenv()

class ServiceAccountKey:

    @staticmethod
    def accountKey():
        type=os.environ.get("TYPE")
        project_id=os.environ.get("PROJECT_ID")
        private_key_id=os.environ.get("PRIVATE_KEY_ID")
        private_key=os.environ.get("PRIVATE_KEY")
        client_email=os.environ.get("CLIENT_EMAIL")
        client_id=os.environ.get("CLIENT_ID")
        auth_uri=os.environ.get("AUTH_URI")
        token_uri=os.environ.get("TOKEN_URI")
        auth_provider_x509_cert_url=os.environ.get("AUTH_PROVIDER_X509_CERT_URL")
        client_x509_cert_url=os.environ.get("CLIENT_X509_CERT_URL")

        key = {
            "type": type,
            'project_id': project_id,
            'private_key_id': private_key_id,
            'private_key': private_key,
            'client_email': client_email,
            'client_id': client_id,
            'auth_uri': auth_uri,
            'token_uri': token_uri,
            'auth_provider_x509_cert_url': auth_provider_x509_cert_url,
            'client_x509_cert_url': client_x509_cert_url
        }

        return key