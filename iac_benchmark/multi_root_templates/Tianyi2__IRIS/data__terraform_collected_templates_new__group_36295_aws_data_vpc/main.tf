data "aws_vpc" "this" {
  region          = var.region
  cidr_block      = var.cidr_block
  dhcp_options_id = var.dhcp_options_id
  default         = var.default
  id              = var.id
  state           = var.state
  tags            = var.tags

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