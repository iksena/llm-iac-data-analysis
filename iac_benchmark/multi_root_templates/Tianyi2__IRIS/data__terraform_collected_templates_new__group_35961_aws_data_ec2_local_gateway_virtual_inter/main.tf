data "aws_ec2_local_gateway_virtual_interface_group" "this" {
  region           = var.region
  id               = var.id
  local_gateway_id = var.local_gateway_id
  tags             = var.tags

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts.read
  }
}