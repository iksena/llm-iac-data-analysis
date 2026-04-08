data "aws_instances" "this" {
  region               = var.region
  instance_tags        = var.instance_tags
  instance_state_names = var.instance_state_names

  dynamic "filter" {
    for_each = var.filters
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