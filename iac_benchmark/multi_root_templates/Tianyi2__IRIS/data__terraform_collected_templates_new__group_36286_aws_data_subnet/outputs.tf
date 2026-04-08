# Arguments (also available as outputs)
output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_subnet.this.region
}

output "availability_zone" {
  description = "Availability zone where the subnet resides."
  value       = data.aws_subnet.this.availability_zone
}

output "availability_zone_id" {
  description = "ID of the Availability Zone for the subnet."
  value       = data.aws_subnet.this.availability_zone_id
}

output "cidr_block" {
  description = "CIDR block of the subnet."
  value       = data.aws_subnet.this.cidr_block
}

output "default_for_az" {
  description = "Whether the subnet is the default subnet for its associated availability zone."
  value       = data.aws_subnet.this.default_for_az
}

output "id" {
  description = "ID of the subnet."
  value       = data.aws_subnet.this.id
}

output "ipv6_cidr_block" {
  description = "IPv6 CIDR block of the subnet."
  value       = data.aws_subnet.this.ipv6_cidr_block
}

output "state" {
  description = "State of the subnet."
  value       = data.aws_subnet.this.state
}

output "tags" {
  description = "Map of tags assigned to the subnet."
  value       = data.aws_subnet.this.tags
}

output "vpc_id" {
  description = "ID of the VPC that the subnet belongs to."
  value       = data.aws_subnet.this.vpc_id
}

# Additional attributes
output "arn" {
  description = "ARN of the subnet."
  value       = data.aws_subnet.this.arn
}

output "assign_ipv6_address_on_creation" {
  description = "Whether an IPv6 address is assigned on creation."
  value       = data.aws_subnet.this.assign_ipv6_address_on_creation
}

output "available_ip_address_count" {
  description = "Available IP addresses of the subnet."
  value       = data.aws_subnet.this.available_ip_address_count
}

output "customer_owned_ipv4_pool" {
  description = "Identifier of customer owned IPv4 address pool."
  value       = data.aws_subnet.this.customer_owned_ipv4_pool
}

output "enable_dns64" {
  description = "Whether DNS queries made to the Amazon-provided DNS Resolver in this subnet return synthetic IPv6 addresses for IPv4-only destinations."
  value       = data.aws_subnet.this.enable_dns64
}

output "enable_lni_at_device_index" {
  description = "Indicates the device position for local network interfaces in this subnet."
  value       = data.aws_subnet.this.enable_lni_at_device_index
}

output "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records."
  value       = data.aws_subnet.this.enable_resource_name_dns_aaaa_record_on_launch
}

output "enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records."
  value       = data.aws_subnet.this.enable_resource_name_dns_a_record_on_launch
}

output "ipv6_cidr_block_association_id" {
  description = "Association ID of the IPv6 CIDR block."
  value       = data.aws_subnet.this.ipv6_cidr_block_association_id
}

output "ipv6_native" {
  description = "Whether this is an IPv6-only subnet."
  value       = data.aws_subnet.this.ipv6_native
}

output "map_customer_owned_ip_on_launch" {
  description = "Whether customer owned IP addresses are assigned on network interface creation."
  value       = data.aws_subnet.this.map_customer_owned_ip_on_launch
}

output "map_public_ip_on_launch" {
  description = "Whether public IP addresses are assigned on instance launch."
  value       = data.aws_subnet.this.map_public_ip_on_launch
}

output "outpost_arn" {
  description = "ARN of the Outpost."
  value       = data.aws_subnet.this.outpost_arn
}

output "owner_id" {
  description = "ID of the AWS account that owns the subnet."
  value       = data.aws_subnet.this.owner_id
}

output "private_dns_hostname_type_on_launch" {
  description = "The type of hostnames assigned to instances in the subnet at launch."
  value       = data.aws_subnet.this.private_dns_hostname_type_on_launch
}