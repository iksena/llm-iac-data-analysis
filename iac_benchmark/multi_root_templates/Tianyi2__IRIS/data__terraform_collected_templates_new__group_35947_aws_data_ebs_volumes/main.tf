data "aws_ebs_volumes" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filters
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