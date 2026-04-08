output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = aws_default_vpc.this.arn
}

output "cidr_block" {
  description = "The primary IPv4 CIDR block for the VPC"
  value       = aws_default_vpc.this.cidr_block
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_default_vpc.this.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = aws_default_vpc.this.default_route_table_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_default_vpc.this.default_security_group_id
}

output "dhcp_options_id" {
  description = "The ID of the set of DHCP options you've associated with the VPC"
  value       = aws_default_vpc.this.dhcp_options_id
}


output "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = aws_default_vpc.this.enable_dns_hostnames
}

output "enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = aws_default_vpc.this.enable_dns_support
}

output "id" {
  description = "The ID of the VPC"
  value       = aws_default_vpc.this.id
}

output "instance_tenancy" {
  description = "The allowed tenancy of instances launched into the VPC"
  value       = aws_default_vpc.this.instance_tenancy
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = aws_default_vpc.this.ipv6_association_id
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = aws_default_vpc.this.ipv6_cidr_block
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_default_vpc.this.main_route_table_id
}

output "owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = aws_default_vpc.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_default_vpc.this.tags_all
}