output "arn" {
  description = "ARN of the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.arn
}

output "cidr_blocks" {
  description = "List of CIDR blocks for the exposed AWS service. Applicable for endpoints of type Gateway"
  value       = data.aws_vpc_endpoint.this.cidr_blocks
}

output "dns_entry" {
  description = "DNS entries for the VPC Endpoint. Applicable for endpoints of type Interface"
  value       = data.aws_vpc_endpoint.this.dns_entry
}

output "dns_options" {
  description = "DNS options for the VPC Endpoint"
  value       = data.aws_vpc_endpoint.this.dns_options
}

output "network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type Interface"
  value       = data.aws_vpc_endpoint.this.network_interface_ids
}

output "owner_id" {
  description = "ID of the AWS account that owns the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.owner_id
}

output "policy" {
  description = "Policy document associated with the VPC Endpoint. Applicable for endpoints of type Gateway"
  value       = data.aws_vpc_endpoint.this.policy
}

output "prefix_list_id" {
  description = "Prefix list ID of the exposed AWS service. Applicable for endpoints of type Gateway"
  value       = data.aws_vpc_endpoint.this.prefix_list_id
}

output "private_dns_enabled" {
  description = "Whether or not the VPC is associated with a private hosted zone - true or false. Applicable for endpoints of type Interface"
  value       = data.aws_vpc_endpoint.this.private_dns_enabled
}

output "requester_managed" {
  description = "Whether or not the VPC Endpoint is being managed by its service - true or false"
  value       = data.aws_vpc_endpoint.this.requester_managed
}

output "route_table_ids" {
  description = "One or more route tables associated with the VPC Endpoint. Applicable for endpoints of type Gateway"
  value       = data.aws_vpc_endpoint.this.route_table_ids
}

output "security_group_ids" {
  description = "One or more security groups associated with the network interfaces. Applicable for endpoints of type Interface"
  value       = data.aws_vpc_endpoint.this.security_group_ids
}


output "subnet_ids" {
  description = "One or more subnets in which the VPC Endpoint is located. Applicable for endpoints of type Interface"
  value       = data.aws_vpc_endpoint.this.subnet_ids
}

output "vpc_endpoint_type" {
  description = "VPC Endpoint type, Gateway or Interface"
  value       = data.aws_vpc_endpoint.this.vpc_endpoint_type
}

output "id" {
  description = "ID of the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.id
}

output "region" {
  description = "Region of the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.region
}

output "service_name" {
  description = "Service name of the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.service_name
}

output "state" {
  description = "State of the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.state
}

output "tags" {
  description = "Map of tags assigned to the VPC endpoint"
  value       = data.aws_vpc_endpoint.this.tags
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc_endpoint.this.vpc_id
}