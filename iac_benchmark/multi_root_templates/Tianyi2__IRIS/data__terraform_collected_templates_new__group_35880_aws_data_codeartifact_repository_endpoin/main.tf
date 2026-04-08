data "aws_codeartifact_repository_endpoint" "this" {
  region       = var.region
  domain       = var.domain
  repository   = var.repository
  format       = var.format
  domain_owner = var.domain_owner
}