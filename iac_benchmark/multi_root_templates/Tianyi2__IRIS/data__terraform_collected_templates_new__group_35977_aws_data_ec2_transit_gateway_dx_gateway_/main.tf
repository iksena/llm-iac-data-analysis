data "aws_ec2_transit_gateway_dx_gateway_attachment" "this" {
  region             = var.region
  transit_gateway_id = var.transit_gateway_id
  dx_gateway_id      = var.dx_gateway_id
  tags               = var.tags

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.read_timeout
  }
}