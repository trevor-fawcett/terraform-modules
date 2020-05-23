provider "aws" {
  region = var.aws_region
}

# CodePipeline IAM Permissions
data "template_file" "codepipeline_assume_role_policy_template" {
  template = file("${path.module}/policies/codepipeline_assume_role.tpl")
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.repo_name}-codepipeline-role"
  assume_role_policy = data.template_file.codepipeline_assume_role_policy_template.rendered
}

data "template_file" "codepipeline_policy_template" {
  template = file("${path.module}/policies/codepipeline.tpl")
  vars = {
    aws_kms_key     = var.artifact_encryption_key_arn
    artifact_bucket = var.build_artifact_bucket_arn
  }
}

resource "aws_iam_role_policy" "attach_codepipeline_policy" {
  name   = "${var.repo_name}-codepipeline-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.template_file.codepipeline_policy_template.rendered
}

# CodePipeline
resource "aws_codepipeline" "codepipeline" {
  name     = var.repo_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.build_artifact_bucket_name
    type     = "S3"

    encryption_key {
      id   = var.artifact_encryption_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = var.repo_provider
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = var.repo_name
        BranchName     = var.repo_branch
      }
    }
  }

  stage {
    name = "Test"

    action {
      name             = "Test"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["tested"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_test_project_name
      }
    }
  }

  stage {
    name = "Package"

    action {
      name             = "Package"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["tested"]
      output_artifacts = ["packaged"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_package_project_name
      }
    }
  }
}