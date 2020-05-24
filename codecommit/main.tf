provider "aws" {
  region = var.aws_region
}

resource "aws_codecommit_repository" "repo" {
  repository_name = var.repo_name
  description     = "${var.repo_name} repository."
  default_branch  = var.repo_default_branch

  provisioner "local-exec" {
    command = "git clone ${aws_codecommit_repository.repo.clone_url_http}"
  }
  
  provisioner "local-exec" {
    command = "cd ${var.repo_name}"
  }
  
  provisioner "local-exec" {
    command = "echo '# ${var.repo_name}' > readme.md"
  }
  
  provisioner "local-exec" {
    command = "git commit -a -m 'initial'"
  }
  
  provisioner "local-exec" {
    command = "git push -u origin ${var.repo_default_branch}"
  }
}