data "aws_ec2_transit_gateway_multicast_domain" "this" {
  region                              = var.region
  transit_gateway_multicast_domain_id = var.transit_gateway_multicast_domain_id

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