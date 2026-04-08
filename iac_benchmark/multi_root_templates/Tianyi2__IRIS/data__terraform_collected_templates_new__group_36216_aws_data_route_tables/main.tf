data "aws_route_tables" "this" {
  region = var.region
  vpc_id = var.vpc_id
  tags   = var.tags

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}