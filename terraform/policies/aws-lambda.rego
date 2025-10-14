package terraform.aws_lambda

deny[msg] {
  some i, k
  input.resource_changes[i].type == "aws_lambda_function"
  env := input.resource_changes[i].change.after.environment.variables
  key := object.keys(env)[k]
  lower(key) == "password" or lower(key) == "secret" or lower(key) == "apikey"
  msg := sprintf("Lambda '%v' exposes a secret in environment variable '%v'.", [input.resource_changes[i].name, key])
}
