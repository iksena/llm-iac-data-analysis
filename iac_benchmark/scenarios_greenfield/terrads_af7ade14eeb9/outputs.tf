output "availability_zones" {
  description = "List of Availability Zones where subnets were created"
  value       = module.subnets.availability_zones
}

output "availability_zone_ids" {
  description = "List of Availability Zones IDs where subnets were created, when available"
  value       = module.subnets.availability_zone_ids
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = module.subnets.public_subnet_ids
}

output "public_subnet_arns" {
  description = "ARNs of the created public subnets"
  value       = module.subnets.public_subnet_arns
}

output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = module.subnets.private_subnet_ids
}

output "private_subnet_arns" {
  description = "ARNs of the created private subnets"
  value       = module.subnets.private_subnet_arns
}

# Provide some consistency in CIDR outputs by always returning a list.
# Avoid (or at least reduce) `count` problems by toggling the return
# value via configuration rather than computing it via `compact()`.
output "public_subnet_cidrs" {
  description = "IPv4 CIDR blocks of the created public subnets"
  value       = module.subnets.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "IPv4 CIDR blocks of the created private subnets"
  value       = module.subnets.private_subnet_cidrs
}

output "public_route_table_ids" {
  description = "IDs of the created public route tables"
  value       = module.subnets.public_route_table_ids
}

output "private_route_table_ids" {
  description = "IDs of the created private route tables"
  value       = module.subnets.private_route_table_ids
}

output "public_network_acl_id" {
  description = "ID of the Network ACL created for public subnets"
  value       = module.subnets.public_network_acl_id
}

output "private_network_acl_id" {
  description = "ID of the Network ACL created for private subnets"
  value       = module.subnets.private_network_acl_id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways created"
  value       = module.subnets.nat_gateway_ids
}

output "nat_instance_ids" {
  description = "IDs of the NAT Instances created"
  value       = module.subnets.nat_instance_ids
}

output "nat_instance_ami_id" {
  description = "ID of AMI used by NAT instance"
  value       = module.subnets.nat_instance_ami_id
}

output "nat_ips" {
  description = "Elastic IP Addresses in use by NAT"
  value       = module.subnets.nat_ips
}

output "nat_eip_allocation_ids" {
  description = "Elastic IP allocations in use by NAT"
  value       = module.subnets.nat_eip_allocation_ids
}

output "az_private_subnets_map" {
  description = "Map of AZ names to list of private subnet IDs in the AZs"
  value       = module.subnets.az_private_subnets_map
}

output "az_public_subnets_map" {
  description = "Map of AZ names to list of public subnet IDs in the AZs"
  value       = module.subnets.az_public_subnets_map
}

output "az_private_route_table_ids_map" {
  description = "Map of AZ names to list of private route table IDs in the AZs"
  value       = module.subnets.az_private_route_table_ids_map
}

output "az_public_route_table_ids_map" {
  description = "Map of AZ names to list of public route table IDs in the AZs"
  value       = module.subnets.az_public_route_table_ids_map
}

output "named_private_subnets_map" {
  description = "Map of subnet names (specified in `subnets_per_az_names` variable) to lists of private subnet IDs"
  value       = module.subnets.named_private_subnets_map
}

output "named_public_subnets_map" {
  description = "Map of subnet names (specified in `subnets_per_az_names` variable) to lists of public subnet IDs"
  value       = module.subnets.named_public_subnets_map
}

output "named_private_route_table_ids_map" {
  description = "Map of subnet names (specified in `subnets_per_az_names` variable) to lists of private route table IDs"
  value       = module.subnets.named_private_route_table_ids_map
}

output "named_public_route_table_ids_map" {
  description = "Map of subnet names (specified in `subnets_per_az_names` variable) to lists of public route table IDs"
  value       = module.subnets.named_public_route_table_ids_map
}

output "named_private_subnets_stats_map" {
  description = "Map of subnet names (specified in `subnets_per_az_names` variable) to lists of objects with each object having three items: AZ, private subnet ID, private route table ID"
  value       = module.subnets.named_private_subnets_stats_map
}

output "named_public_subnets_stats_map" {
  description = "Map of subnet names (specified in `subnets_per_az_names` variable) to lists of objects with each object having three items: AZ, public subnet ID, public route table ID"
  value       = module.subnets.named_public_subnets_stats_map
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "vpc_arn" {
  value       = module.vpc.vpc_arn
  description = "The ARN of the VPC"
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The primary IPv4 CIDR block of the VPC"
}

output "vpc_main_route_table_id" {
  value       = module.vpc.vpc_main_route_table_id
  description = "The ID of the main route table associated with this VPC"
}

output "vpc_default_network_acl_id" {
  value       = module.vpc.vpc_default_network_acl_id
  description = "The ID of the network ACL created by default on VPC creation"
}

output "vpc_default_security_group_id" {
  value       = module.vpc.vpc_default_security_group_id
  description = "The ID of the security group created by default on VPC creation"
}

output "vpc_default_route_table_id" {
  value       = module.vpc.vpc_default_route_table_id
  description = "The ID of the route table created by default on VPC creation"
}

output "additional_cidr_blocks" {
  description = "A list of the additional IPv4 CIDR blocks associated with the VPC"
  value       = module.vpc.additional_cidr_blocks
}

output "additional_cidr_blocks_to_association_ids" {
  description = "A map of the additional IPv4 CIDR blocks to VPC CIDR association IDs"
  value       = module.vpc.additional_cidr_blocks_to_association_ids
}

output "igw_id" {
  value       = module.vpc.igw_id
  description = "The ID of the Internet Gateway"
}

output "vpc_endpoint_sg_id" {
  value = aws_security_group.endpoint_security_group.id
  description = "ID of the security group that allows access to the vpc endpoints"
  
}