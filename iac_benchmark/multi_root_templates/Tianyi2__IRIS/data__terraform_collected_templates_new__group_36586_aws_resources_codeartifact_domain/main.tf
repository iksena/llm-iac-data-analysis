resource "aws_codeartifact_domain" "this" {
  domain         = var.domain
  region         = var.region
  encryption_key = var.encryption_key
  tags           = var.tags
}