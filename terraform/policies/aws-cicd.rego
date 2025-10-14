package aws.cicd

deny[msg] {
  pipeline := input.aws_codepipeline[_]
  not pipeline.artifact_encryption_enabled
  msg := sprintf("Pipeline %s does not have artifact encryption enabled", [pipeline.name])
}

deny[msg] {
  project := input.aws_codebuild_project[_]
  not project.logs_config.cloudwatch_enabled
  msg := sprintf("CodeBuild project %s does not have CloudWatch logs enabled", [project.name])
}
