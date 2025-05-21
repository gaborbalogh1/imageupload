variable "lambda_name" {
  description = "Lambda Function Name"
}

variable "lambda_runtime" {
  description = "Lambda Function Runtime"
}

variable "lambda_handler" {
  default = "handler.lambda_handler"
}

variable "vpc_id" {
  description = "VPC ID to use for the deployment of the Lambda Function"
}

variable "subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "region" {
  description = "The region to deploy the resources"
}

variable "lambda_source_dir" {
  description = "source path of the lambda function"
}

variable "lambda_output_dir" {
  description = "output path of the lambda function"
}
