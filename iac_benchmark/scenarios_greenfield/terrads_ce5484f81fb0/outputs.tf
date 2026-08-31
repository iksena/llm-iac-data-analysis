output "availability_zones" {
  description = "The availability zones of the VPC."
  value       = local.availability_zones
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT gateways."
  value       = aws_nat_gateway.this[*].public_ip
}

output "num_availability_zones" {
  description = "The number of availability zones of the VPC."
  value       = length(local.availability_zones)
}

output "num_nat_gateways" {
  description = "The number of NAT gateways created."
  value       = length(aws_nat_gateway.this)
}

output "private_subnet_cidr_blocks" {
  description = "The CIDR blocks of the private subnets."
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "private_subnet_route_table_id" {
  description = "The ID of the private subnet route table."
  value       = var.create_private_subnets ? aws_route_table.private[0].id : null
}

output "private_subnets" {
  description = "A map of all private subnets, with the subnet name as key, and all aws-subnet properties as the value."
  value = {
    for s in aws_subnet.private : s.tags.Name => {
      availability_zone = s.availability_zone
      cidr_block        = s.cidr_block
      route_table       = aws_route_table.private[0].id
      subnet_id         = s.id
      network_acl       = aws_network_acl.private[0].id
    }
  }
}

output "public_subnet_cidr_blocks" {
  description = "The CIDR blocks of the public subnets."
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "public_subnet_route_table_id" {
  description = "The ID of the public subnet route table."
  value       = var.create_public_subnets ? aws_route_table.public[0].id : null
}

output "public_subnets" {
  description = "A map of all public subnets, with the subnet name as key, and all aws-subnet properties as the value."
  value = {
    for s in aws_subnet.public : s.tags.Name => {
      availability_zone = s.availability_zone
      cidr_block        = s.cidr_block
      route_table       = aws_route_table.public[0].id
      subnet_id         = s.id
      network_acl       = aws_network_acl.public[0].id
    }
  }
}

output "public_subnets_network_acl_id" {
  description = "The ID of the public subnet network ACL."
  value       = var.create_public_subnets ? aws_network_acl.public[0].id : null
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_name" {
  description = "The name of the VPC."
  value       = var.vpc_name
}
