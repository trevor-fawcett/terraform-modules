variable "aws_region" {
  description = "The AWS region to deploy CodeCommit into (default: eu-west-2)."
  default     = "eu-west-2"
}

variable "repo_name" {
  description = "The name of the CodeCommit repository (e.g. new-repo)."
  default     = ""
}

variable "repo_default_branch" {
  description = "The name of the default repository branch (default: master)"
  default     = "master"
}

variable "prevent_destroy" {
  description = "Prevents the repository being destroyed along with other infrastructure (default: true)"
  default     = "true"
}