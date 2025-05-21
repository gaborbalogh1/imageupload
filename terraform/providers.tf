terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.98.0"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Gabor Balogh"
      Project     = "APIGTW-LAMBDA-S3"
    }
  }
}
