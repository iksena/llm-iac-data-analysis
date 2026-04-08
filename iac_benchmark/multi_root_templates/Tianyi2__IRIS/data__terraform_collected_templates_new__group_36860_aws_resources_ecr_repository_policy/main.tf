resource "aws_ecr_repository_policy" "this" {
  region     = var.region
  repository = var.repository
  policy     = var.policy
}