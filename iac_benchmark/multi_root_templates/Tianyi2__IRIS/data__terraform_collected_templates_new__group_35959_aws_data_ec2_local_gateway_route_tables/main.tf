data "aws_ec2_local_gateway_route_tables" "this" {
  region = var.region
  tags   = var.tags

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}