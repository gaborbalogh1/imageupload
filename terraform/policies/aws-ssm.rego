package aws.ssm

deny[msg] {
  param := input.aws_ssm_parameter[_]
  param.type == "String"
  msg := sprintf("SSM parameter %s should be SecureString", [param.name])
}

deny[msg] {
  secret := input.aws_secretsmanager_secret[_]
  not secret.rotation_enabled
  msg := sprintf("Secret %s rotation is not enabled", [secret.name])
}
