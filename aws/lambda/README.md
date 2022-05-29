# Lambda

###Problem
####1.AWS Lambda: Task timed out
- Lambda functions are limited to a maximum execution time of 15 minutes (this was recently increased from the original 5 minutes timeout). The actual limit is configured when the Lambda function is created

Ref: [AWS Lambda: Task timed out](https://stackoverflow.com/questions/43577746/aws-lambda-task-timed-out)

###Reference

[QA] - [How do you specify tagging in put_object?](https://stackoverflow.com/questions/51635286/how-do-you-specify-tagging-in-put-object) \
[QA] - [How to send metadata along with S3 signedUrl in Node.js?](https://pandeysoni.medium.com/how-to-send-metadata-along-with-s3-signedurl-in-node-js-c708aca2b951) \

[CODE] srcecde - [lambda_api_multipart_upload_file](https://github.com/srcecde/aws-tutorial-code/blob/master/lambda/lambda_api_multipart.py) \
[Vid] srcecde - [How to upload file with metadata - Amazon API Gateway p13](https://www.youtube.com/watch?v=NMV4bVTphjU) \
[Blog] Eetu Tuomala - [Uploading objects to S3 using one-time pre signed URLs](https://www.serverless.com/blog/s3-one-time-signed-url/)