data "aws_vpc_security_group_rules" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  tags = var.tags
}