data "aws_codeartifact_authorization_token" "this" {
  region           = var.region
  domain           = var.domain
  domain_owner     = var.domain_owner
  duration_seconds = var.duration_seconds
}