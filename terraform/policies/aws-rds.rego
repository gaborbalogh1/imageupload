package aws.rds

deny[msg] {
  db := input.aws_rds_instance[_]
  db.publicly_accessible
  msg := sprintf("RDS instance %s is publicly accessible", [db.id])
}
