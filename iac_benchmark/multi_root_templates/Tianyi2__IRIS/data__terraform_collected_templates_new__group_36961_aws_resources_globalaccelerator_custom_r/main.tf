resource "aws_globalaccelerator_custom_routing_endpoint_group" "this" {
  listener_arn          = var.listener_arn
  endpoint_group_region = var.endpoint_group_region

  dynamic "destination_configuration" {
    for_each = var.destination_configuration
    content {
      from_port = destination_configuration.value.from_port
      to_port   = destination_configuration.value.to_port
      protocols = destination_configuration.value.protocols
    }
  }

  dynamic "endpoint_configuration" {
    for_each = var.endpoint_configuration
    content {
      endpoint_id = endpoint_configuration.value.endpoint_id
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}