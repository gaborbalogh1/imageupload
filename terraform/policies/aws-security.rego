package terraform.aws_sg

# Deny security groups that allow 0.0.0.0/0 access
deny[msg] {
  some i, j
  input.resource_changes[i].type == "aws_security_group"
  ingress := input.resource_changes[i].change.after.ingress[j]
  cidr := ingress.cidr_blocks[_]
  cidr == "0.0.0.0/0"
  msg := sprintf("Security group '%v' allows ingress from 0.0.0.0/0 on ports %v.", [input.resource_changes[i].name, ingress.from_port])
}
