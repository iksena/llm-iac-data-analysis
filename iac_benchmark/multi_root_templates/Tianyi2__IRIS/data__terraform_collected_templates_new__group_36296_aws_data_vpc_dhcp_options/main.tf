data "aws_vpc_dhcp_options" "this" {
  region          = var.region
  dhcp_options_id = var.dhcp_options_id

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