resource "aws_ecr_lifecycle_policy" "this" {
  region     = var.region
  repository = var.repository
  policy     = var.policy
}