variable "region" {
  description = "Deployment region"
  default     = "eu-west-2"
  type        = string
}

variable "environment" {
  description = "Environment to deploy this service to"
  default     = "test"
  type        = string
}