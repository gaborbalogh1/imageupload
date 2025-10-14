package terraform.aws_s3

# Deny unencrypted S3 buckets
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket"
  bucket := input.resource_changes[i].change.after
  not bucket.server_side_encryption_configuration
  msg := sprintf("S3 bucket '%v' must enable server-side encryption.", [input.resource_changes[i].name])
}

# Deny S3 buckets with public ACLs
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket"
  bucket := input.resource_changes[i].change.after
  bucket.acl
  not bucket.acl == "private"
  msg := sprintf("S3 bucket '%v' must have ACL set to 'private', found '%v'.", [input.resource_changes[i].name, bucket.acl])
}

# Deny buckets without versioning
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket_versioning"
  versioning := input.resource_changes[i].change.after
  not versioning.enabled
  msg := sprintf("S3 bucket versioning must be enabled for '%v'.", [input.resource_changes[i].name])
}
