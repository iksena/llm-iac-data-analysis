resource "aws_ec2_transit_gateway_route_table_association" "this" {
  region                         = var.region
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
  replace_existing_association   = var.replace_existing_association
}