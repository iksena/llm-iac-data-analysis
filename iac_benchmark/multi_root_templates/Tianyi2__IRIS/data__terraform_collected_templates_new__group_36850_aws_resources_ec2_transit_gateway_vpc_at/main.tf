resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  region                                          = var.region
  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  appliance_mode_support                          = var.appliance_mode_support
  dns_support                                     = var.dns_support
  ipv6_support                                    = var.ipv6_support
  security_group_referencing_support              = var.security_group_referencing_support
  tags                                            = var.tags
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
}