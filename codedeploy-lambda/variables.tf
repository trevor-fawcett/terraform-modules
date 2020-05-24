variable "aws_region" {
  description = "The AWS region to deploy CodeBuild into (default: eu-west-2)."
  default     = "eu-west-2"
}

variable "repo_name" {
  description = "The name of the code repository (e.g. new-repo)."
  default     = ""
}
