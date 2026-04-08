data "aws_ec2_transit_gateway_vpn_attachment" "this" {
  region             = var.region
  transit_gateway_id = var.transit_gateway_id
  vpn_connection_id  = var.vpn_connection_id
  tags               = var.tags

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