data "aws_network_acls" "this" {
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

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      read = timeouts.value.read
    }
  }
}