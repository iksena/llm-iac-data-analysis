resource "aws_networkfirewall_firewall" "this" {
  provider = aws.this

  region                              = var.region
  availability_zone_change_protection = var.availability_zone_change_protection
  delete_protection                   = var.delete_protection
  description                         = var.description
  enabled_analysis_types              = var.enabled_analysis_types
  firewall_policy_arn                 = var.firewall_policy_arn
  firewall_policy_change_protection   = var.firewall_policy_change_protection
  name                                = var.name
  subnet_change_protection            = var.subnet_change_protection
  tags                                = var.tags
  transit_gateway_id                  = var.transit_gateway_id
  vpc_id                              = var.vpc_id

  dynamic "availability_zone_mapping" {
    for_each = var.availability_zone_mapping
    content {
      availability_zone_id = availability_zone_mapping.value.availability_zone_id
    }
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      ip_address_type = subnet_mapping.value.ip_address_type
      subnet_id       = subnet_mapping.value.subnet_id
    }
  }
}