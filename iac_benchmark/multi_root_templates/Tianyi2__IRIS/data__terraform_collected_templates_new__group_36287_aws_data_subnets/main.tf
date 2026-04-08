data "aws_subnets" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  tags = var.tags

  timeouts {
    read = var.read_timeout
  }
}