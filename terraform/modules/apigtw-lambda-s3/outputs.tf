output "api_id" {
  value = aws_apigatewayv2_api.http_api.id
}

output "api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "lambda_function_name" {
  value = aws_lambda_function.api_handler.function_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}
