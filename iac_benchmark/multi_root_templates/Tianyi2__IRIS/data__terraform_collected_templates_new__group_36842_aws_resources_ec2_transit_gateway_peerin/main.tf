resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {
  transit_gateway_attachment_id = var.transit_gateway_attachment_id
  region                        = var.region
  tags                          = var.tags
}