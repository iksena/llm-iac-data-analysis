data "aws_ecr_repository_creation_template" "this" {
  region = var.region
  prefix = var.prefix
}