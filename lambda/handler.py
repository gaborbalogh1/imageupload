import json
import uuid
import urllib.request
import boto3
import os

s3 = boto3.client('s3')
BUCKET_NAME = os.environ.get("S3_BUCKET_NAME", "ABUCKET")

def lambda_handler(event, context):
    try:
        # 1. Get a random dog image URL
        api_url = "https://dog.ceo/api/breeds/image/random"
        with urllib.request.urlopen(api_url) as response:
            data = json.loads(response.read().decode())
            image_url = data.get("message")

        if not image_url:
            raise Exception("Image URL not found in API response")

        # 2. Download the image
        with urllib.request.urlopen(image_url) as img_response:
            image_data = img_response.read()

        # 3. Generate unique filename
        file_id = str(uuid.uuid4())
        file_name = f"{file_id}.jpg"

        # 4. Upload to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=image_data,
            ContentType="image/jpeg",
            #ACL="public-read"
        )

        file_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{file_name}"

        # 5. Return success response
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "File uploaded successfully",
                "imageUrl": file_url,
                "sourceImage": image_url
            })
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Internal server error",
                "error": str(e)
            })
        }
