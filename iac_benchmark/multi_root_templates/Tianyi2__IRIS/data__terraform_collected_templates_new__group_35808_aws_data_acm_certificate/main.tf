data "aws_acm_certificate" "this" {
  region      = var.region
  domain      = var.domain
  key_types   = var.key_types
  statuses    = var.statuses
  types       = var.types
  most_recent = var.most_recent
  tags        = var.tags
}