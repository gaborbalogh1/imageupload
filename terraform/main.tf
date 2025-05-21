module "serverless-vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnets = {
    pub1 = { cidr = "10.0.1.0/24", az = "eu-west-2a" }
    pub2 = { cidr = "10.0.2.0/24", az = "eu-west-2b" }
  }

  private_subnets = {
    priv1 = { cidr = "10.0.101.0/24", az = "eu-west-2a" }
    priv2 = { cidr = "10.0.102.0/24", az = "eu-west-2b" }
  }

}

module "serverless-app" {
  source = "./modules/apigtw-lambda-s3"

  lambda_name       = "api-to-s3-lambda"
  lambda_runtime    = "python3.11"
  lambda_source_dir = "../lambda/"
  lambda_output_dir = "../lambda/lambda.zip"

  vpc_id     = module.serverless-vpc.vpc_id
  subnet_ids = module.serverless-vpc.private_subnet_ids
}

# Optional Configure custom domain
# module "custom_domain" {
#   source              = "./modules/api-route53-certs"

#   api_gtw_id = module.serverless.api_id
#   custom_domain_name  = "YOUR_CUSTOM_DOMAIN"
#   create_route53_record = true
#   hosted_zone_id      = "YOUR_CUSTOM_DOMAIN_HOSTED_ZONE_ID"
# }
