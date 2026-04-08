data "aws_opensearchserverless_lifecycle_policy" "this" {
  region = var.region
  name   = var.name
  type   = var.type
}