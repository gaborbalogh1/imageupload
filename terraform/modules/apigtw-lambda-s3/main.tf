data "aws_iam_policy_document" "lambda_s3_put_only" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.lambda_bucket.arn,
      "${aws_s3_bucket.lambda_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      aws_kms_key.ssec_only_bucket.arn
    ]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "lambda_s3_put_only" {
  name        = "LambdaS3PutOnlyPolicy"
  description = "Allow Lambda to put objects and set ACLs in a specific S3 bucket"
  policy      = data.aws_iam_policy_document.lambda_s3_put_only.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_put_only_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_s3_put_only.arn
}

resource "aws_kms_key" "ssec_only_bucket" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}


resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.lambda_name}-bucket-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "block_public_acls" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ssec_only_bucket_encryption" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ssec_only_bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = var.lambda_output_dir
}

resource "aws_lambda_function" "api_handler" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  timeout       = 10
  filename      = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.lambda_bucket.bucket
    }
  }
}

data "aws_prefix_list" "s3" {
  name = "com.amazonaws.eu-west-2.s3"
}

resource "aws_security_group" "lambda_sg" {
  name        = "${var.lambda_name}-sg"
  description = "Allow Lambda to access S3 via VPC endpoint"
  vpc_id      = var.vpc_id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    description     = "This allows Lambda to send HTTPS requests through the VPC"
    prefix_list_ids = [data.aws_prefix_list.s3.id]
  }

  tags = {
    Name = "${var.lambda_name}-sg"
  }
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.lambda_name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api_handler.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "PUT /uploads"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_access_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "api_gw_access_logs" {
  name              = "/aws/api-gateway/upload-api-access-logs"
  retention_in_days = 14 # Optional: keeps logs for 14 days

  #kms_key_id = aws_kms_key.cloudwatch_logs.key_id
}

# resource "aws_kms_key" "cloudwatch_logs" {
#   description             = "CMK for API Gateway access logs"
#   deletion_window_in_days = 10

#   enable_key_rotation = true
# }

resource "aws_cloudwatch_log_resource_policy" "api_gw_policy" {
  policy_name = "ApiGwLogsPolicy"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action   = "logs:PutLogEvents"
        Resource = [aws_cloudwatch_log_group.api_gw_access_logs.arn]
      }
    ]
  })
}


resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
