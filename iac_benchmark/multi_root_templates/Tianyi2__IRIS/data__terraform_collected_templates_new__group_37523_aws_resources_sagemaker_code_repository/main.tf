resource "aws_sagemaker_code_repository" "this" {
  region               = var.region
  code_repository_name = var.code_repository_name
  tags                 = var.tags

  git_config {
    repository_url = var.git_config_repository_url
    branch         = var.git_config_branch
    secret_arn     = var.git_config_secret_arn
  }
}