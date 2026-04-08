resource "aws_lightsail_lb_certificate" "this" {
  domain_name               = var.domain_name
  lb_name                   = var.lb_name
  name                      = var.name
  region                    = var.region
  subject_alternative_names = var.subject_alternative_names
}