data "aws_ec2_transit_gateway_connect_peer" "this" {
  region                          = var.region
  transit_gateway_connect_peer_id = var.transit_gateway_connect_peer_id

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}