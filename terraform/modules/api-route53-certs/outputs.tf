output "custom_api_domain" {
  value       = try(aws_apigatewayv2_domain_name.custom[0].domain_name, null)
  description = "Custom domain name for the API Gateway"
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.api_cert.arn
}

