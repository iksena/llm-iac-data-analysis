resource "aws_ec2_transit_gateway_multicast_group_source" "this" {
  region                              = var.region
  group_ip_address                    = var.group_ip_address
  network_interface_id                = var.network_interface_id
  transit_gateway_multicast_domain_id = var.transit_gateway_multicast_domain_id
}