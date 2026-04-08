resource "aws_ec2_transit_gateway_multicast_domain" "this" {
  region                          = var.region
  transit_gateway_id              = var.transit_gateway_id
  auto_accept_shared_associations = var.auto_accept_shared_associations
  igmpv2_support                  = var.igmpv2_support
  static_sources_support          = var.static_sources_support
  tags                            = var.tags

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}