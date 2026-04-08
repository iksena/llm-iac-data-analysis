data "aws_vpc_peering_connections" "this" {
  region = var.region
  tags   = var.tags

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