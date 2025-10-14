package terraform.aws_rds

# Deny publicly accessible RDS instances
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_db_instance"
  db := input.resource_changes[i].change.after
  db.publicly_accessible
  msg := sprintf("RDS instance '%v' must not be publicly accessible.", [input.resource_changes[i].name])
}

# Deny RDS without storage encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_db_instance"
  db := input.resource_changes[i].change.after
  not db.storage_encrypted
  msg := sprintf("RDS instance '%v' must have storage encryption enabled.", [input.resource_changes[i].name])
}
