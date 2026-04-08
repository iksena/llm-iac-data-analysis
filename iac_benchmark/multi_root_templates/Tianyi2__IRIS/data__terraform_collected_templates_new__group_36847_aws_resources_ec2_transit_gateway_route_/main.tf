resource "aws_ec2_transit_gateway_route_table" "this" {
  region             = var.region
  transit_gateway_id = var.transit_gateway_id
  tags               = var.tags
}