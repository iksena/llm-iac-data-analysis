output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = aws_vpc.this.arn
}

output "id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = aws_vpc.this.instance_tenancy
}

output "dhcp_options_id" {
  description = "DHCP options id of the desired VPC."
  value       = aws_vpc.this.dhcp_options_id
}

output "enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = aws_vpc.this.enable_dns_support
}

output "enable_network_address_usage_metrics" {
  description = "Whether Network Address Usage metrics are enabled for the VPC"
  value       = aws_vpc.this.enable_network_address_usage_metrics
}

output "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = aws_vpc.this.enable_dns_hostnames
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association."
  value       = aws_vpc.this.main_route_table_id
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.this.default_network_acl_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.this.default_security_group_id
}

output "default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = aws_vpc.this.default_route_table_id
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block."
  value       = aws_vpc.this.ipv6_association_id
}

output "ipv6_cidr_block_network_border_group" {
  description = "The Network Border Group Zone name"
  value       = aws_vpc.this.ipv6_cidr_block_network_border_group
}

output "owner_id" {
  description = "The ID of the AWS account that owns the VPC."
  value       = aws_vpc.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc.this.tags_all
}