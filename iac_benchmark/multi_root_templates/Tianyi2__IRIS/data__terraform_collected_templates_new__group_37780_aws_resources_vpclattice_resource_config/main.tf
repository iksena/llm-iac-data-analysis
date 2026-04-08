resource "aws_vpclattice_resource_configuration" "this" {
  name                                           = var.name
  port_ranges                                    = var.port_ranges
  allow_association_to_shareable_service_network = var.allow_association_to_shareable_service_network
  protocol                                       = var.protocol
  region                                         = var.region
  resource_configuration_group_id                = var.resource_configuration_group_id
  resource_gateway_identifier                    = var.resource_gateway_identifier
  type                                           = var.type
  tags                                           = var.tags

  dynamic "resource_configuration_definition" {
    for_each = var.resource_configuration_definition != null ? [var.resource_configuration_definition] : []
    content {
      dynamic "arn_resource" {
        for_each = resource_configuration_definition.value.arn_resource != null ? [resource_configuration_definition.value.arn_resource] : []
        content {
          arn = arn_resource.value.arn
        }
      }

      dynamic "dns_resource" {
        for_each = resource_configuration_definition.value.dns_resource != null ? [resource_configuration_definition.value.dns_resource] : []
        content {
          domain_name     = dns_resource.value.domain_name
          ip_address_type = dns_resource.value.ip_address_type
        }
      }

      dynamic "ip_resource" {
        for_each = resource_configuration_definition.value.ip_resource != null ? [resource_configuration_definition.value.ip_resource] : []
        content {
          ip_address = ip_resource.value.ip_address
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}