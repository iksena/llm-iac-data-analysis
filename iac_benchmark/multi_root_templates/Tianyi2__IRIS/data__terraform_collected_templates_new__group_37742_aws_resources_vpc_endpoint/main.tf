resource "aws_vpc_endpoint" "this" {
  region                     = var.region
  vpc_id                     = var.vpc_id
  auto_accept                = var.auto_accept
  policy                     = var.policy
  private_dns_enabled        = var.private_dns_enabled
  ip_address_type            = var.ip_address_type
  resource_configuration_arn = var.resource_configuration_arn
  route_table_ids            = var.route_table_ids
  service_name               = var.service_name
  service_network_arn        = var.service_network_arn
  service_region             = var.service_region
  subnet_ids                 = var.subnet_ids
  security_group_ids         = var.security_group_ids
  tags                       = var.tags
  vpc_endpoint_type          = var.vpc_endpoint_type

  dynamic "dns_options" {
    for_each = var.dns_options != null ? [var.dns_options] : []
    content {
      dns_record_ip_type                             = dns_options.value.dns_record_ip_type
      private_dns_only_for_inbound_resolver_endpoint = dns_options.value.private_dns_only_for_inbound_resolver_endpoint
    }
  }

  dynamic "subnet_configuration" {
    for_each = var.subnet_configuration
    content {
      ipv4      = subnet_configuration.value.ipv4
      ipv6      = subnet_configuration.value.ipv6
      subnet_id = subnet_configuration.value.subnet_id
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}