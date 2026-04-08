resource "aws_wafv2_ip_set" "this" {
  region             = var.region
  name               = var.name
  name_prefix        = var.name_prefix
  description        = var.description
  scope              = var.scope
  ip_address_version = var.ip_address_version
  addresses          = var.addresses
  tags               = var.tags
}