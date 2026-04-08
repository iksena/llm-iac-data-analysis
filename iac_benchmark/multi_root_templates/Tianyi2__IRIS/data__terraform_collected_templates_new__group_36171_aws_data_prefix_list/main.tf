data "aws_prefix_list" "this" {
  region         = var.region
  prefix_list_id = var.prefix_list_id
  name           = var.name

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts.read
  }
}