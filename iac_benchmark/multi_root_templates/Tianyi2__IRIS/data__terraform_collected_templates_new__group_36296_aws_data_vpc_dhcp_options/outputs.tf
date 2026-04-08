output "arn" {
  description = "ARN of the DHCP Options Set"
  value       = data.aws_vpc_dhcp_options.this.arn
}

output "dhcp_options_id" {
  description = "EC2 DHCP Options ID"
  value       = data.aws_vpc_dhcp_options.this.dhcp_options_id
}

output "domain_name" {
  description = "Suffix domain name to used when resolving non Fully Qualified Domain Names"
  value       = data.aws_vpc_dhcp_options.this.domain_name
}

output "domain_name_servers" {
  description = "List of name servers"
  value       = data.aws_vpc_dhcp_options.this.domain_name_servers
}

output "id" {
  description = "EC2 DHCP Options ID"
  value       = data.aws_vpc_dhcp_options.this.id
}

output "ipv6_address_preferred_lease_time" {
  description = "How frequently, in seconds, a running instance with an IPv6 assigned to it goes through DHCPv6 lease renewal"
  value       = data.aws_vpc_dhcp_options.this.ipv6_address_preferred_lease_time
}

output "netbios_name_servers" {
  description = "List of NETBIOS name servers"
  value       = data.aws_vpc_dhcp_options.this.netbios_name_servers
}

output "netbios_node_type" {
  description = "NetBIOS node type (1, 2, 4, or 8)"
  value       = data.aws_vpc_dhcp_options.this.netbios_node_type
}

output "ntp_servers" {
  description = "List of NTP servers"
  value       = data.aws_vpc_dhcp_options.this.ntp_servers
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = data.aws_vpc_dhcp_options.this.tags
}

output "owner_id" {
  description = "ID of the AWS account that owns the DHCP options set"
  value       = data.aws_vpc_dhcp_options.this.owner_id
}