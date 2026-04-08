data "aws_network_interface" "this" {
  region = var.region
  id     = var.id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.read_timeout
  }
}