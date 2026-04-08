data "aws_internet_gateway" "this" {
  region              = var.region
  internet_gateway_id = var.internet_gateway_id
  tags                = var.tags

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.read_timeout
  }
}