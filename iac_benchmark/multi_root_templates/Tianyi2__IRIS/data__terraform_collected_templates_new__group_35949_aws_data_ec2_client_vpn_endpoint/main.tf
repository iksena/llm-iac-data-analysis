data "aws_ec2_client_vpn_endpoint" "this" {
  region                 = var.region
  client_vpn_endpoint_id = var.client_vpn_endpoint_id
  tags                   = var.tags

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