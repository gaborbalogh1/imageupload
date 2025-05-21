import base64
import boto3
import json
import os
import uuid

BUCKET_NAME = os.environ.get("BUCKET_NAME")

def lambda_handler(event, context):
    try:
        image_data = base64.b64decode(event["body"])
        #Generate unique filename
        file_id = str(uuid.uuid4())
        filename = f"{file_id}.jpg"

        s3 = boto3.client('s3')
        s3.put_object(Bucket=BUCKET_NAME, Key=filename, Body=image_data)

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Upload successful", "filename": filename})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Upload failed", "error": str(e)})
        }
