package aws.asg

deny[msg] {
  asg := input.aws_autoscaling_group[_]
  lt := asg.launch_template
  not lt.encrypted
  msg := sprintf("ASG %s uses unencrypted launch template %s", [asg.name, lt.id])
}
