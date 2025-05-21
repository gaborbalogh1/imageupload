module "pic-to-s3-vpc" {
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

module "serverless" {
  source = "./modules/apigtw-lambda-s3"

  lambda_name       = "api-to-s3-lambda"
  lambda_runtime    = "python3.11"
  lambda_source_dir = "../lambda/"
  lambda_output_dir = "../lambda/lambda.zip"

  vpc_id     = module.pic-to-s3-vpc.vpc_id
  subnet_ids = module.pic-to-s3-vpc.private_subnet_ids
}

# Optional
# module "custom_domain" {
#   source              = "./modules/api-route53-certs"

#   api_gtw_id = module.serverless.api_id
#   custom_domain_name  = "test.gabaltech.co.uk"
#   create_route53_record = true
#   hosted_zone_id      = "Z01517093AJJC8T5LXDV3"
# }
