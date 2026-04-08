resource "aws_globalaccelerator_custom_routing_listener" "this" {
  accelerator_arn = var.accelerator_arn

  dynamic "port_range" {
    for_each = var.port_ranges
    content {
      from_port = port_range.value.from_port
      to_port   = port_range.value.to_port
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}