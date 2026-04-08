data "aws_autoscaling_groups" "this" {
  region = var.region
  names  = var.names

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}