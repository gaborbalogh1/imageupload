package terraform.aws_serverless

# Deny public API Gateway endpoints without authorization
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_api_gateway_rest_api"
  api := input.resource_changes[i].change.after
  not api.endpoint_configuration.types[_] == "PRIVATE"
  msg := sprintf("API Gateway '%v' must not be public without proper authorization.", [input.resource_changes[i].name])
}

# Deny SNS topics without encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_sns_topic"
  topic := input.resource_changes[i].change.after
  not topic.kms_master_key_id
  msg := sprintf("SNS topic '%v' must use KMS encryption.", [input.resource_changes[i].name])
}

# Deny SQS queues without encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_sqs_queue"
  queue := input.resource_changes[i].change.after
  not queue.kms_master_key_id
  msg := sprintf("SQS queue '%v' must use KMS encryption.", [input.resource_changes[i].name])
}

# Deny DynamoDB tables without encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_dynamodb_table"
  table := input.resource_changes[i].change.after
  not table.server_side_encryption.enabled
  msg := sprintf("DynamoDB table '%v' must have server-side encryption enabled.", [input.resource_changes[i].name])
}
