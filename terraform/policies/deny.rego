package policy

deny[msg] {
  some p
  msg := data.aws.ebs.deny[_]
} else {
  some p
  msg := data.aws.rds.deny[_]
} else {
  some p
  msg := data.aws.lambda.deny[_]
} else {
  some p
  msg := data.aws.serverless.deny[_]
} else {
  some p
  msg := data.aws.cicd.deny[_]
} else {
  some p
  msg := data.aws.ssm.deny[_]
} else {
  some p
  msg := data.aws.asg.deny[_]
} else {
  some p
  msg := data.aws.security.deny[_]
}
