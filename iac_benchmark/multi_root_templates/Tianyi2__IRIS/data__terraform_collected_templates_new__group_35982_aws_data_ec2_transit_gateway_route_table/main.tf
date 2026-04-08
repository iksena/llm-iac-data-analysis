data "aws_ec2_transit_gateway_route_table_associations" "this" {
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
  region                         = var.region

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}