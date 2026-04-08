resource "aws_ec2_transit_gateway" "this" {
  region                             = var.region
  amazon_side_asn                    = var.amazon_side_asn
  auto_accept_shared_attachments     = var.auto_accept_shared_attachments
  default_route_table_association    = var.default_route_table_association
  default_route_table_propagation    = var.default_route_table_propagation
  description                        = var.description
  dns_support                        = var.dns_support
  security_group_referencing_support = var.security_group_referencing_support
  multicast_support                  = var.multicast_support
  tags                               = var.tags
  transit_gateway_cidr_blocks        = var.transit_gateway_cidr_blocks
  vpn_ecmp_support                   = var.vpn_ecmp_support

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}