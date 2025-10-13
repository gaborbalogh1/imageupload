package terraform.deny

deny[msg] {
  input.resource_changes[_].type == "aws_s3_bucket"
  not input.resource_changes[_].change.after.acl == "private"
  msg = "S3 bucket must have ACL set to private"
}
