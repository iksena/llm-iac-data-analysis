data "aws_security_group" "this" {
  region = var.region
  id     = var.id
  name   = var.name
  tags   = var.tags
  vpc_id = var.vpc_id

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