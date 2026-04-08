resource "aws_vpn_gateway_route_propagation" "this" {
  region         = var.region
  vpn_gateway_id = var.vpn_gateway_id
  route_table_id = var.route_table_id

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}