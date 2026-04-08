data "aws_network_interfaces" "this" {
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