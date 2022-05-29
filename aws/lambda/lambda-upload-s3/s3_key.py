import uuid
import boto3
import os
import json
import urllib.parse
bucket_name = os.environ['BUCKET_NAME']
put_s3_pre_fix='input/nft-image'
mimeType={
    'flv':'video/x-flv',
    'mp4':'video/mp4',
    'm3u8':'application/x-mpegURL',
    'ts':'video/MP2T',
    'MP2T':'video/MP2T',
    '3gp':'video/3gpp',
    'mov':'video/quicktime',
    'avi':'video/x-msvideo',
    'wmv':'video/x-ms-wmv',
    'mp3':'audio/mpeg',
    'au':'audio/basic',
    'snd':'audio/basic',
    'mid':'audio/mid',
    'rmi':'audio/mid',
    'm3u':'audio/x-mpegurl',
    'wav':'audio/vnd.wav',
    'flac':'audio/flac',
    'webm':'video/webm',
    'mpeg':'video/mpeg',
    'mpg':'video/mpg',
    'mkv':'video/webm'
}

class S3Key:
    def __init__(self,userId,token):
        self.s3=boto3.client('s3')
        self.userId=userId
        self.token=str(token)
        self.pre_fix='input'
    
    def generateS3Key(self,imageId,nftType,nftId,previewImgId='',start_time='',end_time=''):
        print("imageId: " + imageId)
        filename,file_extension=os.path.splitext(imageId)
        nftExtention=file_extension[1:]
        contentType=''
        middle_s3_key=''
        if nftType=='video':
            middle_s3_key='nft-media'
            if nftExtention in mimeType:
                contentType=mimeType[nftExtention]
            else:
                print('not support for extention:',nftExtention)

        if nftType=='preview':
            middle_s3_key='nft-preview'
            contentType='image'+'/'+nftExtention
        put_s3_pre_fix= self.pre_fix+ '/'+ middle_s3_key
        
        print(contentType)
        tagging='token={}&nft_id={}&preview_img_id={}&user_id={}&start_time={}&end_time={}'.format(
            self.token,nftId,previewImgId,self.userId,start_time,end_time
        )

        print(tagging)
        s3_key=put_s3_pre_fix+'/'+str(self.userId)+'/'+imageId
        
        return {
            'tagging':tagging,
            'path':s3_key,
            'content_type': contentType
        }