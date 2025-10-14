package aws.serverless

deny contains msg if {
  api := input.aws_api_gateway[_]
  not api.logging_enabled
  msg := sprintf("API Gateway %s does not have logging enabled", [api.name])
}

deny contains msg if {
  queue := input.aws_sqs_queue[_]
  not queue.encryption_enabled
  msg := sprintf("SQS queue %s is not encrypted", [queue.name])
}

deny contains msg if {
  topic := input.aws_sns_topic[_]
  not topic.encryption_enabled
  msg := sprintf("SNS topic %s is not encrypted", [topic.name])
}

deny contains msg if {
  table := input.aws_dynamodb_table[_]
  not table.encryption_enabled
  msg := sprintf("DynamoDB table %s is not encrypted", [table.name])
}
