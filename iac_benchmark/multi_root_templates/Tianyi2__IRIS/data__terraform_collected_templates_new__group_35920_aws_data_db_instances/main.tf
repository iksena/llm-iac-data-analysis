data "aws_db_instances" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  tags = var.tags
}