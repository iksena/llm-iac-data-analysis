resource "aws_lightsail_domain" "this" {
  domain_name = var.domain_name
  region      = var.region
}