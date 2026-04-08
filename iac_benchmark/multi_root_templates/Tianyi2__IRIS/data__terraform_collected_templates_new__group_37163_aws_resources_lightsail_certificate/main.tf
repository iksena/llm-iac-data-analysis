resource "aws_lightsail_certificate" "this" {
  name                      = var.name
  domain_name               = var.domain_name
  region                    = var.region
  subject_alternative_names = var.subject_alternative_names
  tags                      = var.tags
}