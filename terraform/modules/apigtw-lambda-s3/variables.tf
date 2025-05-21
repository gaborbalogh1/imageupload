variable "lambda_name" {
  description = "Lambda Function Name"
  type        = string
}

variable "lambda_runtime" {
  description = "Lambda Function Runtime"
  type        = string
}

variable "lambda_handler" {
  default = "handler.lambda_handler"
  type    = string
}

variable "vpc_id" {
  description = "VPC ID to use for the deployment of the Lambda Function"
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "lambda_source_dir" {
  description = "source path of the lambda function"
  type        = string
}

variable "lambda_output_dir" {
  description = "output path of the lambda function"
  type        = string
}
