data "aws_ec2_transit_gateway_peering_attachment" "this" {
  region = var.region
  id     = var.id
  tags   = var.tags

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      read = timeouts.value.read
    }
  }
}