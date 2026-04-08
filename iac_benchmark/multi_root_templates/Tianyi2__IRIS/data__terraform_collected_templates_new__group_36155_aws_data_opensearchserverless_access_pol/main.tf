data "aws_opensearchserverless_access_policy" "this" {
  name   = var.name
  type   = var.type
  region = var.region
}