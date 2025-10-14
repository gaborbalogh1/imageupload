package aws.ebs

deny[msg] {
  volume := input.aws_ebs_volume[_]
  not volume.encrypted
  msg := sprintf("EBS volume %s is not encrypted", [volume.id])
}

