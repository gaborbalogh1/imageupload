package aws.lambda

deny[msg] {
  fn := input.aws_lambda_function[_]
  env := fn.environment.variables
  some k, v
  lower(k) == "password" or lower(k) == "secret" or lower(k) == "apikey"
  msg := sprintf("Lambda %s has sensitive env variable: %s", [fn.name, k])
}
