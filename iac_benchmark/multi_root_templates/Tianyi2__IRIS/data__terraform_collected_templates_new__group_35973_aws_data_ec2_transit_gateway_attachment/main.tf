data "aws_ec2_transit_gateway_attachment" "this" {
  region                        = var.region
  transit_gateway_attachment_id = var.transit_gateway_attachment_id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}