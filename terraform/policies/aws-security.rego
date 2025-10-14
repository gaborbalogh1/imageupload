package aws.security

deny[msg] {
  sg := input.aws_security_group[_]
  rule := sg.ingress[_]
  rule.cidr_blocks[_] == "0.0.0.0/0"
  msg := sprintf("Security group %s allows ingress from 0.0.0.0/0", [sg.name])
}
