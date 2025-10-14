package terraform.aws_cicd

# Deny CodeBuild projects without encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_codebuild_project"
  project := input.resource_changes[i].change.after
  not project.encryption_key
  msg := sprintf("CodeBuild project '%v' must have encryption_key configured.", [input.resource_changes[i].name])
}

# Deny CodePipeline without artifact encryption
deny[msg] {
  some i
  input.resource_changes[i].type == "aws_codepipeline"
  pipeline := input.resource_changes[i].change.after
  not pipeline.artifact_store.encryption_key
  msg := sprintf("CodePipeline '%v' must encrypt artifacts using KMS.", [input.resource_changes[i].name])
}
