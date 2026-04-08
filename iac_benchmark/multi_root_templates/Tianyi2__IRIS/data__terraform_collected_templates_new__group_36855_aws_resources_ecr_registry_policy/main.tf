resource "aws_ecr_registry_policy" "this" {
  region = var.region
  policy = var.policy
}