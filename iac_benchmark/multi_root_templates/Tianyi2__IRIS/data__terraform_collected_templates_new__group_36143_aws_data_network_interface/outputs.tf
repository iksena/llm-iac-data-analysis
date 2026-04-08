output "arn" {
  description = "ARN of the network interface."
  value       = data.aws_network_interface.this.arn
}

output "association" {
  description = "Association information for an Elastic IP address (IPv4) associated with the network interface."
  value       = data.aws_network_interface.this.association
}

output "attachment" {
  description = "Attachment of the ENI."
  value       = data.aws_network_interface.this.attachment
}

output "availability_zone" {
  description = "Availability Zone."
  value       = data.aws_network_interface.this.availability_zone
}

output "description" {
  description = "Description of the network interface."
  value       = data.aws_network_interface.this.description
}

output "interface_type" {
  description = "Type of interface."
  value       = data.aws_network_interface.this.interface_type
}

output "ipv6_addresses" {
  description = "List of IPv6 addresses to assign to the ENI."
  value       = data.aws_network_interface.this.ipv6_addresses
}

output "mac_address" {
  description = "MAC address."
  value       = data.aws_network_interface.this.mac_address
}

output "owner_id" {
  description = "AWS account ID of the owner of the network interface."
  value       = data.aws_network_interface.this.owner_id
}

output "private_dns_name" {
  description = "Private DNS name."
  value       = data.aws_network_interface.this.private_dns_name
}

output "private_ip" {
  description = "Private IPv4 address of the network interface within the subnet."
  value       = data.aws_network_interface.this.private_ip
}

output "private_ips" {
  description = "Private IPv4 addresses associated with the network interface."
  value       = data.aws_network_interface.this.private_ips
}

output "requester_id" {
  description = "ID of the entity that launched the instance on your behalf."
  value       = data.aws_network_interface.this.requester_id
}

output "security_groups" {
  description = "List of security groups for the network interface."
  value       = data.aws_network_interface.this.security_groups
}

output "subnet_id" {
  description = "ID of the subnet."
  value       = data.aws_network_interface.this.subnet_id
}

output "outpost_arn" {
  description = "ARN of the Outpost."
  value       = data.aws_network_interface.this.outpost_arn
}

output "tags" {
  description = "Any tags assigned to the network interface."
  value       = data.aws_network_interface.this.tags
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = data.aws_network_interface.this.vpc_id
}

output "id" {
  description = "Identifier for the network interface."
  value       = data.aws_network_interface.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_network_interface.this.region
}

output "filter" {
  description = "Applied filters for the network interface lookup."
  value       = var.filter
}