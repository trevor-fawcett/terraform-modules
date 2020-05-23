variable "aws_region" {
  description = "The AWS region to deploy CodeBuild into (default: eu-west-2)."
  default     = "eu-west-2"
}

variable "repo_provider" {
  description = "The repository provider (default: CodeCommit)"
  default = "CodeCommit"
}

variable "repo_name" {
  description = "The name of the code repository (e.g. new-repo)."
  default     = ""
}

variable "repo_branch" {
  description = "The branch of the repository to be processed by the pipeline (default: master)"
  default = "master"
}

variable "artifact_encryption_key" {
  description = "The KMS key used to encrypt the artifact"
  default = ""
}

variable "build_artifact_bucket" {
  description = "The S3 Bucket that will receive build artifacts"
  default = ""
}

variable "codebuild_test_project" {
  description = "The CodeBuild project to be used during the test stage of the pipeline"
  default = ""
}

variable "codebuild_package_project" {
  description = "The CodeBuild project to be used during the package stage of the pipeline"
  default = ""
}