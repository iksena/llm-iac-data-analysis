resource "aws_ses_domain_identity_verification" "this" {
  domain = var.domain
  region = var.region

  timeouts {
    create = var.timeouts.create
  }
}