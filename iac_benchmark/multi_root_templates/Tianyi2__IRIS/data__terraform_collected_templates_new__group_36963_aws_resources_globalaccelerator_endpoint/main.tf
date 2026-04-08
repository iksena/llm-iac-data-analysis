resource "aws_globalaccelerator_endpoint_group" "this" {
  listener_arn                  = var.listener_arn
  endpoint_group_region         = var.endpoint_group_region
  health_check_interval_seconds = var.health_check_interval_seconds
  health_check_path             = var.health_check_path
  health_check_port             = var.health_check_port
  health_check_protocol         = var.health_check_protocol
  threshold_count               = var.threshold_count
  traffic_dial_percentage       = var.traffic_dial_percentage

  dynamic "endpoint_configuration" {
    for_each = var.endpoint_configuration
    content {
      attachment_arn                 = endpoint_configuration.value.attachment_arn
      client_ip_preservation_enabled = endpoint_configuration.value.client_ip_preservation_enabled
      endpoint_id                    = endpoint_configuration.value.endpoint_id
      weight                         = endpoint_configuration.value.weight
    }
  }

  dynamic "port_override" {
    for_each = var.port_override
    content {
      endpoint_port = port_override.value.endpoint_port
      listener_port = port_override.value.listener_port
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}