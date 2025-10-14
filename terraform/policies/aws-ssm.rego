package terraform.aws_ssm

# Deny SSM Parameters that are not SecureString
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_ssm_parameter"
  param := input.resource_changes[i].change.after
  not param.type == "SecureString"
  msg := sprintf("SSM parameter '%v' must use SecureString type.", [input.resource_changes[i].name])
}

# Deny Secrets Manager secrets without KMS encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_secretsmanager_secret"
  secret := input.resource_changes[i].change.after
  not secret.kms_key_id
  msg := sprintf("Secrets Manager secret '%v' must specify a KMS key for encryption.", [input.resource_changes[i].name])
}
