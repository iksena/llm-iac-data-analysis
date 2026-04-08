resource "aws_opensearchserverless_lifecycle_policy" "this" {
  name        = var.name
  policy      = var.policy
  type        = var.type
  region      = var.region
  description = var.description
}