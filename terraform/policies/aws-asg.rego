package terraform.aws_asg

# Deny Launch Templates without encrypted root volume
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_launch_template"
  lt := input.resource_changes[i].change.after
  not lt.block_device_mappings[_].ebs.encrypted
  msg := sprintf("Launch Template '%v' must have encrypted EBS volumes.", [input.resource_changes[i].name])
}

# Deny AutoScaling Groups without instance protection
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_autoscaling_group"
  asg := input.resource_changes[i].change.after
  not asg.protect_from_scale_in
  msg := sprintf("AutoScaling Group '%v' must enable instance protection.", [input.resource_changes[i].name])
}
