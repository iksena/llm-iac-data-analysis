output "region" {
  description = "AWS region"
  value       = var.region
}

output "cidr_block" {
  description = "CIDR block for the VPC"
  value       = var.cidr_block
}

output "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  value       = var.public_subnet_cidrs
}

output "common_tags" {
  description = "Common tags for all resources"
  value       = var.common_tags
}

output "env" {
  description = "Environment name"
  value       = var.env
}

output "developer" {
    description = "List of developers"
    value       = var.developer
}

output "ingress_ports" {
    description = "Security group ports"
    value       = var.ingress_ports
}

output "instance_type" {
    description = "Instance type"
    value       = var.instance_type
}