data "aws_ecr_repositories" "this" {
  region = var.region
}