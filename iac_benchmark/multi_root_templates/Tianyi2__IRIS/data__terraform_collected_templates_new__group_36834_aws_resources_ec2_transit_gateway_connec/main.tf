resource "aws_ec2_transit_gateway_connect_peer" "this" {
  region                        = var.region
  bgp_asn                       = var.bgp_asn
  inside_cidr_blocks            = var.inside_cidr_blocks
  peer_address                  = var.peer_address
  tags                          = var.tags
  transit_gateway_address       = var.transit_gateway_address
  transit_gateway_attachment_id = var.transit_gateway_attachment_id

  timeouts {
    create = "10m"
    delete = "10m"
  }
}