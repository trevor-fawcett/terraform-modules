provider "aws" {
  region = var.aws_region
}

locals {
  unique_name = "${var.repo_name}-${var.codebuild_purpose}"
}

# CodeBuild IAM Permissions
data "template_file" "codebuild_assume_role_policy_template" {
  template = file("${path.module}/policies/codebuild_assume_role.tpl")
}

resource "aws_iam_role" "codebuild_assume_role" {
  name               = "${local.unique_name}-codebuild-role"
  assume_role_policy = data.template_file.codebuild_assume_role_policy_template.rendered
}

data "template_file" "codebuild_policy_template" {
  template = file("${path.module}/policies/codebuild.tpl")
  vars = {
    artifact_bucket   = var.build_artifact_bucket_arn
    aws_kms_key       = var.artifact_encryption_key_arn
    codebuild_project = aws_codebuild_project.codebuild_project.id
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${local.unique_name}-codebuild-policy"
  role   = aws_iam_role.codebuild_assume_role.id
  policy = data.template_file.codebuild_policy_template.rendered
}

# CodeBuild Project
resource "aws_codebuild_project" "codebuild_project" {
  name           = local.unique_name
  description    = "The CodeBuild project for ${var.repo_name} (${var.codebuild_purpose})"
  service_role   = aws_iam_role.codebuild_assume_role.arn
  build_timeout  = var.build_timeout
  encryption_key = var.artifact_encryption_key_arn

  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.build_privileged_override
  }

  source {
    type      = var.source_type
    buildspec = var.buildspec_file
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${local.unique_name}-codebuild-log-group"
      stream_name = "${local.unique_name}-codebuild-log-stream"
    }
  }
}