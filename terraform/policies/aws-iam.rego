package terraform.aws_iam

# Deny IAM policies that allow wildcard actions or resources
deny[msg] {
  some i, j
  input.resource_changes[i].type == "aws_iam_policy"
  statement := input.resource_changes[i].change.after.policy.Statement[j]
  statement.Effect == "Allow"
  (
    statement.Action[_] == "*"
    or
    statement.Resource[_] == "*"
  )
  msg := sprintf("IAM policy '%v' allows overly permissive access (*).", [input.resource_changes[i].name])
}
