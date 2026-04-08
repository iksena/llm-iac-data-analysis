output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_vpc.this.region
}

output "cidr_block" {
  description = "CIDR block of the VPC."
  value       = data.aws_vpc.this.cidr_block
}

output "dhcp_options_id" {
  description = "DHCP options ID of the VPC."
  value       = data.aws_vpc.this.dhcp_options_id
}

output "default" {
  description = "Whether the VPC is the default VPC for the region."
  value       = data.aws_vpc.this.default
}

output "id" {
  description = "ID of the VPC."
  value       = data.aws_vpc.this.id
}

output "state" {
  description = "Current state of the VPC."
  value       = data.aws_vpc.this.state
}

output "tags" {
  description = "Map of tags assigned to the VPC."
  value       = data.aws_vpc.this.tags
}

output "arn" {
  description = "ARN of VPC."
  value       = data.aws_vpc.this.arn
}

output "enable_dns_support" {
  description = "Whether or not the VPC has DNS support."
  value       = data.aws_vpc.this.enable_dns_support
}

output "enable_network_address_usage_metrics" {
  description = "Whether Network Address Usage metrics are enabled for your VPC."
  value       = data.aws_vpc.this.enable_network_address_usage_metrics
}

output "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support."
  value       = data.aws_vpc.this.enable_dns_hostnames
}

output "instance_tenancy" {
  description = "Allowed tenancy of instances launched into the selected VPC."
  value       = data.aws_vpc.this.instance_tenancy
}

output "ipv6_association_id" {
  description = "Association ID for the IPv6 CIDR block."
  value       = data.aws_vpc.this.ipv6_association_id
}

output "ipv6_cidr_block" {
  description = "IPv6 CIDR block."
  value       = data.aws_vpc.this.ipv6_cidr_block
}

output "main_route_table_id" {
  description = "ID of the main route table associated with this VPC."
  value       = data.aws_vpc.this.main_route_table_id
}

output "owner_id" {
  description = "ID of the AWS account that owns the VPC."
  value       = data.aws_vpc.this.owner_id
}

output "cidr_block_associations" {
  description = "CIDR block associations for the VPC."
  value       = data.aws_vpc.this.cidr_block_associations
}