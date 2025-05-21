variable "custom_domain_name" {
  description = "Fully qualified domain name for the API (e.g., api.example.com)"
  type        = string
  default     = ""
}

variable "create_route53_record" {
  type    = bool
  default = false
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
  default     = ""
}

variable "api_gtw_id" {
  description = "API Gateway ID"
  type = string
}