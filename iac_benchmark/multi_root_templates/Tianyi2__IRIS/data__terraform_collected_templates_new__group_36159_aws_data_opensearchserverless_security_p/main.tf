data "aws_opensearchserverless_security_policy" "this" {
  region = var.region
  name   = var.name
  type   = var.type
}