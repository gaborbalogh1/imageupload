package terraform.aws_ebs

deny[msg] {
  some i
  input.resource_changes[i].type == "aws_ebs_volume"
  vol := input.resource_changes[i].change.after
  not vol.encrypted
  msg := sprintf("EBS volume '%v' must have encryption enabled.", [input.resource_changes[i].name])
}
