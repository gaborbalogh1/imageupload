resource "aws_apigatewayv2_domain_name" "custom" {
  count               = var.custom_domain_name != "" ? 1 : 0
  domain_name         = var.custom_domain_name
  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api_cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "custom" {
  count         = var.custom_domain_name != "" ? 1 : 0
  api_id        = var.api_gtw_id
  domain_name   = aws_apigatewayv2_domain_name.custom[0].domain_name
  stage         = "$default"
  api_mapping_key = ""  # root path
}

resource "aws_route53_record" "apigw" {
  count = var.create_route53_record && var.custom_domain_name != "" ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = var.custom_domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.custom[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.custom[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "api_cert" {
  domain_name       = var.custom_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "API Gateway Custom Domain Certificate"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}
