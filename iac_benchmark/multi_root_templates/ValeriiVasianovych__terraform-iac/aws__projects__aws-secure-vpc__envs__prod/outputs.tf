# VPC Information
output "vpc_region" {
  value       = module.aws_vpc.region
  description = "The AWS region of the VPC."
}

output "vpc_env" {
  value       = module.aws_vpc.env
  description = "The environment of the VPC."
}

output "vpc_id" {
  value       = module.aws_vpc.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr_block" {
  value       = module.aws_vpc.vpc_cidr_block
  description = "The CIDR block of the VPC."
}

# Subnet Information
output "public_subnet_cidr_blocks" {
  value       = module.aws_vpc.public_subnet_cidr_blocks
  description = "The CIDR blocks of the public subnets."
}

output "public_subnet_ids" {
  value       = module.aws_vpc.public_subnet_ids
  description = "The IDs of the public subnets."
}

output "private_subnet_cidr_blocks" {
  value       = module.aws_vpc.private_subnet_cidr_blocks
  description = "The CIDR blocks of the private subnets."
}

output "private_subnet_ids" {
  value       = module.aws_vpc.private_subnet_ids
  description = "The IDs of the private subnets."
}

output "db_private_subnet_cidr_blocks" {
  value       = module.aws_vpc.db_private_subnet_cidr_blocks
  description = "The CIDR blocks of the database private subnets."
}

output "db_private_subnet_ids" {
  value       = module.aws_vpc.db_private_subnet_ids
  description = "The IDs of the database private subnets."
}

# Instance Information
// output "bastion_instance_id" {
//   value       = module.aws_compute.bastion_instance_id
//   description = "List of IDs of the bastion instances managed by the ASG. Bastion hosts are used as secure jump servers to access private resources."
// }

// output "bastion_instance_ip" {
//   value       = module.aws_compute.bastion_instance_ip
//   description = "List of public IPs of the bastion instances managed by the ASG. These IPs are used to SSH into the bastion hosts for accessing private resources."
// }

// output "bastion_host_azs" {
//   value       = module.aws_compute.bastion_host_azs
//   description = "List of Availability Zones of the bastion instances. Bastion hosts are distributed across AZs for high availability."
// }

output "private_instance_id" {
  value       = module.aws_compute.private_instance_id
  description = "List of IDs of the private instances managed by the ASG."
}

output "private_instance_ip" {
  value       = module.aws_compute.private_instance_ip
  description = "List of private IPs of the private instances managed by the ASG."
}

output "private_instances_azs" {
  value       = module.aws_compute.private_instances_azs
  description = "List of Availability Zones of the private instances."
}

# DNS Information
output "application_domain_name" {
  value       = module.aws_compute.application_domain_name
  description = "The fully qualified domain name (FQDN) of the application, or null if no private subnets are created."
}
