data "aws_codecommit_repository" "this" {
  region          = var.region
  repository_name = var.repository_name
}