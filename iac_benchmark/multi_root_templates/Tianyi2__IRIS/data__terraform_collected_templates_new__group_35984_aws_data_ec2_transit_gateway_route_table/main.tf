data "aws_ec2_transit_gateway_route_table_routes" "this" {
  region                         = var.region
  transit_gateway_route_table_id = var.transit_gateway_route_table_id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}