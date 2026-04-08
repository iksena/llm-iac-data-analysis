resource "aws_ec2_transit_gateway_default_route_table_association" "this" {
  region                         = var.region
  transit_gateway_id             = var.transit_gateway_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}