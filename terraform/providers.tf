terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.98.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = "Gabor Balogh"
      Project     = "APIGTW-LAMBDA-S3"
    }
  }
}
