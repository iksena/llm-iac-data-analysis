resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  region                                          = var.region
  transit_gateway_attachment_id                   = var.transit_gateway_attachment_id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags                                            = var.tags
}