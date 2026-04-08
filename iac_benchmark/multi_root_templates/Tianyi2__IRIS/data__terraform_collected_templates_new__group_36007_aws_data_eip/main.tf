data "aws_eip" "this" {
  region    = var.region
  id        = var.id
  public_ip = var.public_ip
  tags      = var.tags

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