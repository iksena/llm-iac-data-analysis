resource "aws_route53_resolver_endpoint" "this" {
  region                 = var.region
  direction              = var.direction
  name                   = var.name
  protocols              = var.protocols
  resolver_endpoint_type = var.resolver_endpoint_type
  security_group_ids     = var.security_group_ids
  tags                   = var.tags

  dynamic "ip_address" {
    for_each = var.ip_addresses
    content {
      ip        = ip_address.value.ip
      ipv6      = ip_address.value.ipv6
      subnet_id = ip_address.value.subnet_id
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}