data "aws_ec2_local_gateway" "this" {
  region = var.region
  id     = var.id
  state  = var.state
  tags   = var.tags

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}