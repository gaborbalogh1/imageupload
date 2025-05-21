# aws-save-pic-to-s3
Deploy a Serverless stack to process picture upload to s3 bucket

# Pre requisite
# Install terraform
chmod +x install.sh
sudo ./install.sh

# Validate installation
terraform -version

# Deployed resources
VPC
API Gateway
Lambda Function and IAM Role with policy in the same VPC
S3 bucket and bucket policy