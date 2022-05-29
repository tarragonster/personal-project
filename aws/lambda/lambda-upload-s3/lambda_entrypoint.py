import json
import base64
import email
import boto3
import os
from be_webhook import BeWebhook
from s3_key import S3Key

bucket_name = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    token=event['requestContext']['authorizer']['token']
    userId=event['requestContext']['authorizer']['userid']
    s3 = boto3.client("s3")

    # decoding form-data into bytes
    post_data = base64.b64decode(event['body'])
    # fetching content-type
    try:
        content_type = event['headers']['Content-Type']
    except:
        content_type = event['headers']['content-type']
    # concate Content-Type: with content_type from event
    ct = 'Content-Type: ' + content_type + '\n'

    # parsing message from bytes
    msg = email.message_from_bytes(ct.encode() + post_data)

    # checking if the message is multipart
    print('Multipart check : ', msg.is_multipart())
    
    if msg.is_multipart():
        multipart_content = {}
        # retrieving form-data
        for part in msg.get_payload():
            # checking if filename exist as a part of content-disposition header
            if part.get_filename():
                # fetching the filename
                file_name = part.get_filename()
            multipart_content[
                part.get_param('name', header='content-disposition')
            ] = part.get_payload(decode=True)
    
        print(str(multipart_content['data']))
        
        metaData=json.loads(multipart_content['data'])['meta']
        print(metaData)
        metaCreateNft=metaData['metaApi']
        print(metaCreateNft)
        
        beWebhook=BeWebhook(token,userId)
        # create nft to huukmarket backend
        nftRes=beWebhook.createNftMetaData(metaCreateNft)
        
    
        if nftRes['statusCode'] != 201:
            return nftRes['message']
        else:
            nft=nftRes['data']
            print(nft)
            imageId=metaData['metaPreview']['imageId']
            nftType=metaData['metaPreview']['type']
            # get key and tag
            s3Key=S3Key(userId,token)
            
            previewKey=s3Key.generateS3Key(imageId,nftType,nft['id'])
            
            # uploading file to S3
            s3UploadPreview=s3.put_object(
                Bucket=bucket_name, 
                Key=previewKey['path'], 
                Body=multipart_content["preview"],
                Tagging=previewKey['tagging'],
                ContentType=previewKey['content_type']
            )
            
            if s3UploadPreview['ResponseMetadata']['HTTPStatusCode'] != 200:
                return {"statusCode": 500, "body": json.dumps("Upload failed!")}
            else:
                videoId=metaData['metaVideo']['imageId']
                nftVideoType=metaData['metaVideo']['type']
                previewImgId=previewKey['path'].replace('input','output')
                startTime=metaData['metaVideo']['startTime']
                endTime=metaData['metaVideo']['endTime']
                print('previewImgId: ' + previewImgId)
                videoKey=s3Key.generateS3Key(videoId,nftVideoType,nft['id'],previewImgId,startTime,endTime)
                
                s3UploadVideo=s3.put_object(
                    Bucket=bucket_name, 
                    Key=videoKey['path'], 
                    Body=multipart_content["video"],
                    Tagging=videoKey['tagging'],
                    ContentType=videoKey['content_type']
                )
            
                return {"statusCode": 200, "body": json.dumps("File uploaded successfully!")}
    else:
        return {"statusCode": 500, "body": json.dumps("Upload failed!")}