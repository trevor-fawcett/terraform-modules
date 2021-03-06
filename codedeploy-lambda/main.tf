provider "aws" {
  region = var.aws_region
}

# CodeDeploy IAM Permissions
data "template_file" "codedeploy_assume_role_policy_template" {
  template = file("${path.module}/policies/codedeploy_assume_role.tpl")
}

resource "aws_iam_role" "codedeploy_assume_role" {
  name               = "${var.repo_name}-codedeploy-role"
  assume_role_policy = data.template_file.codedeploy_assume_role_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_assume_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
}

# CodeDeploy Configuration (Lambda)
resource "aws_codedeploy_app" "codedeploy_application" {
  name             = var.repo_name
  compute_platform = "Lambda"
}

resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_application.name
  deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"
  deployment_group_name  = "${var.repo_name}-deployment-group"
  service_role_arn       = aws_iam_role.codedeploy_assume_role.arn
}