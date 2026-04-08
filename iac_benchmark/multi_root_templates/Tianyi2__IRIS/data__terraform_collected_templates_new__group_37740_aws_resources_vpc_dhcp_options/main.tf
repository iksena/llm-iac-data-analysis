resource "aws_vpc_dhcp_options" "this" {
  region                            = var.region
  domain_name                       = var.domain_name
  domain_name_servers               = var.domain_name_servers
  ipv6_address_preferred_lease_time = var.ipv6_address_preferred_lease_time
  ntp_servers                       = var.ntp_servers
  netbios_name_servers              = var.netbios_name_servers
  netbios_node_type                 = var.netbios_node_type
  tags                              = var.tags
}