resource "aws_opensearchserverless_security_policy" "this" {
  name        = var.name
  policy      = var.policy
  type        = var.type
  description = var.description
  region      = var.region
}