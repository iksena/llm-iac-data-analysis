resource "aws_lightsail_domain_entry" "this" {
  domain_name = var.domain_name
  name        = var.name
  target      = var.target
  type        = var.type
  is_alias    = var.is_alias
  region      = var.region
}