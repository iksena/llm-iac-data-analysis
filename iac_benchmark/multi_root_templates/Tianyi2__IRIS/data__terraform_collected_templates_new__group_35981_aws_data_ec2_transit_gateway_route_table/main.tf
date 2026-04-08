data "aws_ec2_transit_gateway_route_table" "this" {
  region = var.region
  id     = var.id

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}