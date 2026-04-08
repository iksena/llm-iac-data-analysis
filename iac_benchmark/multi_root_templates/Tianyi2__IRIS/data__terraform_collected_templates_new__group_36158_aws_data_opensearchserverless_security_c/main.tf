data "aws_opensearchserverless_security_config" "this" {
  id     = var.id
  region = var.region
}