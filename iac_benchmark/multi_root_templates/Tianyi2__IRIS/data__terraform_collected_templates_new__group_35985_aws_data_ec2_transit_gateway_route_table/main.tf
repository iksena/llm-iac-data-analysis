data "aws_ec2_transit_gateway_route_tables" "this" {
  region = var.region
  tags   = var.tags

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