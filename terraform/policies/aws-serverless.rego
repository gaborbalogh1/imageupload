package aws.serverless

deny[msg] {
  api := input.aws_api_gateway[_]
  not api.logging_enabled
  msg := sprintf("API Gateway %s does not have logging enabled", [api.name])
}

deny[msg] {
  queue := input.aws_sqs_queue[_]
  not queue.encryption_enabled
  msg := sprintf("SQS queue %s is not encrypted", [queue.name])
}

deny[msg] {
  topic := input.aws_sns_topic[_]
  not topic.encryption_enabled
  msg := sprintf("SNS topic %s is not encrypted", [topic.name])
}

deny[msg] {
  table := input.aws_dynamodb_table[_]
  not table.encryption_enabled
  msg := sprintf("DynamoDB table %s is not encrypted", [table.name])
}
